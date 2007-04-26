Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbXDZTr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbXDZTr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbXDZTr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:47:59 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:48991 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbXDZTr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:47:57 -0400
Date: Thu, 26 Apr 2007 21:43:56 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Stephen.Clark@seclark.us, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070426194356.GB7352@electric-eye.fr.zoreil.com>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <4630E00B.3090502@tmr.com> <4630E9C8.5060000@garzik.org> <20070426183602.GT3468@stusta.de> <20070426185851.GA7352@electric-eye.fr.zoreil.com> <4630F9CB.10600@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4630F9CB.10600@garzik.org>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> :
> Francois Romieu wrote:
> >Pointer for the rtl8139 regression please ?
> 
> I'm guessing it's this one:
> 
> >	Subject    : boot failure: rtl8139: exception in interrupt routine
> >	References : http://lkml.org/lkml/2007/3/31/160
> >	Submitter  : Stephen Clark <Stephen.Clark@seclark.us>
> >	Status     : unknown
> 
> 
> The poster says rtl8139, but doesn't provide more info.  His lspci says 
> "RTL8169SC", which sounds more like r8169 to me.

Yes, thanks.

The r8169 driver has been added a few bugfixes between 2.6.21-rc5 and now.
Some are related to latent, timing changes induced bugs.

Stephen, would you mind testing 2.6.21 and open a PR at bugzilla.kernel.org
if the bug does not go away ?

Bugzilla e-mails end directly in my mailbox. l-k traffic can be temporarily
unnoticed (especially on saturday night).

-- 
Ueimor

Anybody got a battery for my Ultra 10 ?
