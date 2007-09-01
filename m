Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbXIAVJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbXIAVJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 17:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbXIAVJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 17:09:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37464 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbXIAVJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 17:09:23 -0400
Date: Sun, 2 Sep 2007 02:51:53 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andi Kleen <ak@suse.de>
cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       len.brown@intel.com, linux-ide@vger.kernel.org, dz@debian.org,
       minyard@acm.org, j.w.r.degoede@hhs.nl, lm-sensors@lm-sensors.org,
       rlove@rlove.org, bzolnier@gmail.com, dmitry.torokhov@gmail.com,
       mzxreary@0pointer.de, stelian@popies.net, ibm-acpi@hmh.eng.br,
       ambx1@neo.rr.com, gimli@dark-green.com
Subject: Re: [PATCH] drivers/firmware: const-ify DMI API and internals
In-Reply-To: <200709011833.08581.ak@suse.de>
Message-ID: <alpine.LFD.0.999.0709020249190.20781@enigma.security.iitk.ac.in>
References: <20070901142719.GA31990@havoc.gtf.org>
 <200709011833.08581.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 1 Sep 2007, Andi Kleen wrote:
> 
> >     And if we're really lucky, this might enable some additional
> >     optimizations on the part of the compiler.
> 
> Only if the kernel was compiled C++. C compilers generally ignore constness
> for optimization purposes because it can be so easily casted away.

???

I can't speak for the exact const-ification that Jeff did in this
particular patch, but if you intended your comment up there to be a
blanket statement, then you're totally and horribly wrong. There's a
whole plethora of optimizations that gcc does when dealing with const-
marked data. If you've seen / experienced otherwise, please post some
testcases.
