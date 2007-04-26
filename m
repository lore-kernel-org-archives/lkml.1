Return-Path: <linux-kernel-owner+w=401wt.eu-S1031396AbXDZSFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031396AbXDZSFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031392AbXDZSFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:05:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60065 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031396AbXDZSFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:05:37 -0400
Message-ID: <4630E9C8.5060000@garzik.org>
Date: Thu, 26 Apr 2007 14:04:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <4630E00B.3090502@tmr.com>
In-Reply-To: <4630E00B.3090502@tmr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

IMO, the closer you look, the more warts you find.  Before you starting 
doing your work with kernel regressions, no one was really tracking it. 
  I bet you have helped cut down on the regressions, but I have no good 
way to quantify my gut feeling.

Additional comments on developers and fixing regressions:

* Sometimes seeing a long list, peoples' eyes glaze over.  Its just 
human nature.  A long list also gives us no idea of scale, or severity. 
  I bet a weekly "top 10 bugs and regressions" email would help focus 
developer attention.

* To be effective, lists, either long or top-10, must be pruned if you 
get a sense that only one user is affected.  [With oopses and BUGs as a 
clear exception,] many problems benefit from at least two users 
reporting a bug.

* It gets a bit tiresome to field the large number of driver bug reports 
that eventually turn out to be related to broken interrupt handling 
somehow.  I think we developers need to get better at showing users how 
to isolate driver vs. PCI/ACPI/core bugs.  Maybe drivers need to start 
introducing interrupt delivery tests into their probe code.  Overall, 
broken interrupt handling manifests in several ways, most of which 
initially appear symptomatic of a broken driver.

	Jeff


