Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbXENSoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbXENSoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 14:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbXENSoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 14:44:13 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602AbXENSoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 14:44:12 -0400
Date: Mon, 14 May 2007 11:43:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Antonino Ingargiola <tritemio@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
In-Reply-To: <20070514202419.33a90f57@hyperion.delvare>
Message-ID: <alpine.LFD.0.98.0705141139560.6739@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
 <5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com>
 <alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>
 <5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com>
 <20070514081022.7fcee97f@hyperion.delvare> <5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com>
 <20070514141437.631fcfd1@hyperion.delvare> <5486cca80705140628w5ff43ebdqf6a5413203226d5@mail.gmail.com>
 <20070514172138.1c870793@hyperion.delvare>
 <alpine.LFD.0.98.0705140914410.6739@woody.linux-foundation.org>
 <20070514202419.33a90f57@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 May 2007, Jean Delvare wrote:
> 
> Sure, we don't allow that. Except for xfsprogs in 2.6.1, procps in
> 2.6.4, oprofile in 2.6.13 and udev in 2.6.19, of course.

And we really complained about it! The oprofile thing should be fixed, 
btw, and yeah,if udev breaks any more, I'll have to stop taking patches 
from Greg. That thing has been a disaster, and everybody involved should 
be ashamed and now hopefully *very* aware of the fact that we don't break 
user-level interfaces.

(Right now, I suspect we may have a loop setup regression. Not sure)

> We already have CONFIG_SYSFS_DEPRECATED for that.

..and that should have been made more clear. I certainly didn't react to 
it immediately.

			Linus
