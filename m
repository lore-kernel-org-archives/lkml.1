Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbXEQIw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbXEQIw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 04:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbXEQIww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 04:52:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35617 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752694AbXEQIww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 04:52:52 -0400
Date: Thu, 17 May 2007 09:56:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Christian <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org,
       ak@suse.de
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
Message-ID: <20070517095630.1797800f@the-village.bc.nu>
In-Reply-To: <20070517004209.GE16810@redhat.com>
References: <464B9D2C.7040704@cv-sv.de>
	<20070517004209.GE16810@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  > May be some other non Intel/AMD need to be excluded from X86_CMPXCHG64 ?
>  > May be the generic option CONFIG_X86_GENERIC need to switch this off also ?
> 
> The C3s all have cx8, but it needs to be enabled in an MSR first.
> (See arch/i386/kernel/cpu/centaur.c , search for CX8)

And on the resume path from S2RAM...
