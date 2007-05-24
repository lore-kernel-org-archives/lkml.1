Return-Path: <linux-kernel-owner+w=401wt.eu-S1762833AbXEXCRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762833AbXEXCRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 22:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760752AbXEXCQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 22:16:49 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760222AbXEXCQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 22:16:47 -0400
Date: Wed, 23 May 2007 19:16:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] IDE fixes
In-Reply-To: <alpine.LFD.0.98.0705231850520.3890@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0705231914430.3890@woody.linux-foundation.org>
References: <200705240246.19039.bzolnier@gmail.com>
 <alpine.LFD.0.98.0705231850520.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 May 2007, Linus Torvalds wrote:
> 
> So please, please, please, realize that the compiler is _stupid_, and 
> fixing warnings without understanding the code is bad.

Btw, this is fundamental. If you don't need to understand the code, then 
the compiler could have just fixed it for you, and there was no need to 
warn.

So compiler warnings have two cases:

 - the compiler is being a complete a**hole, and the warning should exist. 
   It happens.
 - it can be fixed, but only by understanding what the code wants to do.

In no case is it ok to just "shut up the warning". 

		Linus
