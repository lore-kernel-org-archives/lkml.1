Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbYEIXiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbYEIXiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 19:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756485AbYEIXh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 19:37:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756427AbYEIXh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 19:37:57 -0400
Date: Fri, 9 May 2008 16:37:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: enable hpet=force for AMD SB400
Message-Id: <20080509163731.5f851bec.akpm@linux-foundation.org>
In-Reply-To: <20080509094911.GG5023@alberich.amd.com>
References: <20080509094911.GG5023@alberich.amd.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008 11:49:11 +0200
Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> x86: enable hpet=force for ATI SB400

Sigh.

> Add quirk to allow forced usage of HPET on ATI SB400.
> I stumbled over machines where HPET is enabled but not reported
> by BIOS.

Is there no way in which we can probe for or identify this condition,
rather than hoping that the user will find out about this boot option?

