Return-Path: <linux-kernel-owner+w=401wt.eu-S934080AbXEPU5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080AbXEPU5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759514AbXEPU5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:57:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40771 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756541AbXEPU5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:57:09 -0400
Date: Wed, 16 May 2007 13:44:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com,
       David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       Dave Airlie <airlied@linux.ie>, linux-ide@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Oleg Nesterov <oleg@tv-sign.ru>, Alex Dubov <oakad@yahoo.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [2/3] 2.6.22-rc1: known regressions v2
In-Reply-To: <Pine.LNX.4.64.0705161333140.11079@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.98.0705161343470.3890@woody.linux-foundation.org>
References: <464B6743.9000607@googlemail.com> <464B6A2B.9020703@googlemail.com>
 <Pine.LNX.4.64.0705161333140.11079@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 May 2007, Christoph Lameter wrote:

> On Wed, 16 May 2007, Michal Piotrowski wrote:
> 
> > Memory management
> > 
> > Subject    : kernel BUG at include/linux/slub_def.h:88 kmalloc_index()
> > References : http://bugzilla.kernel.org/show_bug.cgi?id=8476
> > Submitter  : Cherwin R. Nooitmeer <cherwin@gmail.com>
> > Status     : Unknown
> 
> 
> This a kmalloc(0) that needs fixing.

Well, "needs fixing" is a bit strong.

It's a scary message for something we've always handled, and that we still 
handle fine, we just complain about it.

So we'll probably just turn the message off for 2.6.22, but in the 
meantime, we leave it on and try to fix as many of these as we can be 
bothered to.

		Linus
