Return-Path: <linux-kernel-owner+w=401wt.eu-S932646AbXHaKkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbXHaKkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 06:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbXHaKjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 06:39:54 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57018 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757277AbXHaKjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 06:39:53 -0400
Date: Fri, 31 Aug 2007 10:03:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Dittmer <jdi@l4x.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org
Subject: Re: [1/4] 2.6.23-rc4: known regressions
Message-ID: <20070831080351.GD9260@stusta.de>
References: <46D5902C.1040905@googlemail.com> <46D5B544.4030708@l4x.org> <20070829234734.GA26410@stusta.de> <Pine.LNX.4.64.0708291736010.4526@schroedinger.engr.sgi.com> <46D66D49.20300@l4x.org> <Pine.LNX.4.64.0708301112030.7975@schroedinger.engr.sgi.com> <46D7108D.9090104@l4x.org> <Pine.LNX.4.64.0708310043250.14694@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708310043250.14694@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 12:48:45AM -0700, Christoph Lameter wrote:
> Here is the fix for alpha:
> 
> >From clameter@sgi.com Thu Aug 30 14:13:57 2007
> Subject: SLUB: Force inlining for functions in slub_def.h
> 
> Some compilers (especially older gcc releases) may skip inlining sometimes 
> which will lead to link failures. Force the inlining of keyfunctions in 
> slub_def.h to avoid these issues.
>...

This also explains why it's an Alpha-only problem - the Alpha port 
pretty much diverges from the rest of the kernel regarding "inline" 
semantics and usage...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

