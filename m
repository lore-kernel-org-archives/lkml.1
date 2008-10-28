Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbYJ1XZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbYJ1XZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYJ1XYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:24:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753455AbYJ1XYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:24:43 -0400
Date: Tue, 28 Oct 2008 16:23:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: linux-next: Tree for October 28
Message-Id: <20081028162345.72b3180f.akpm@linux-foundation.org>
In-Reply-To: <20081028160045.2a890509.akpm@linux-foundation.org>
References: <20081028183055.fbcf5420.sfr@canb.auug.org.au>
	<20081028160045.2a890509.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 16:00:45 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> 
> x86_64 allnoconfig:
> 
> arch/x86/kernel/genx2apic_uv_x.c: In function 'uv_rtc_init':
> arch/x86/kernel/genx2apic_uv_x.c:355: error: implicit declaration of function 'uv_bios_freq_base'

oop, seems that this was caused by the presence of a stale
include/asm-x86/uv/bios.h.
