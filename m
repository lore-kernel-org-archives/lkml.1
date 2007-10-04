Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbXJDOMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbXJDOMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 10:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbXJDOM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 10:12:27 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57291 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755844AbXJDOM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 10:12:26 -0400
Date: Thu, 4 Oct 2007 16:12:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Alexander Viro <viro@ftp.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux
	2.6.23-rc9 and a heads-up for the 2.6.24 series..)
Message-ID: <20071004141251.GG10852@stusta.de>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <20071003084607.GC32218@elte.hu> <alpine.LFD.0.999.0710030804310.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710030804310.3579@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 08:11:05AM -0700, Linus Torvalds wrote:
>...
> and btw, there is no question what-so-ever about whether your compiler 
> might be doing a legal optimization - the compiler really is wrong, and is 
> total shit. You need to make a gcc bug-report.
>...

Ingo can't send a gcc bug-report since gcc 4.0 is no longer supported 
upstream and a 4.1.2 compiler was confirmed to work.

Our only options are to either stop supporting the broken gcc versions 
as compiler for the kernel or to work around this compiler bug in the 
kernel.

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

