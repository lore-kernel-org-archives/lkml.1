Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbYKZNnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbYKZNnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYKZNmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:42:55 -0500
Received: from www.tglx.de ([62.245.132.106]:33721 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbYKZNmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:42:54 -0500
Date: Wed, 26 Nov 2008 14:41:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@googlemail.com
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, eranian@gmail.com,
       sfr@canb.auug.org.au
Subject: Re: [patch 06/24] perfmon: generic x86 definitions (x86)
In-Reply-To: <492d0be4.09b6660a.1678.ffffa78b@mx.google.com>
Message-ID: <alpine.LFD.2.00.0811261440330.3325@localhost.localdomain>
References: <492d0be4.09b6660a.1678.ffffa78b@mx.google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, eranian@googlemail.com wrote:

> This patch adds definitions for the perfmon interrupt vector
> and thread info flags. It is common to i386 and x86_64 code.

> +#define TIF_PERFMON_WORK	9	/* work for pfm_handle_work() */

I can see the requirement for an apic vector, but why do you need a
TIF flag ?

Thanks,

	tglx

