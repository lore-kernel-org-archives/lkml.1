Return-Path: <linux-kernel-owner+w=401wt.eu-S936757AbZDCUSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936757AbZDCUSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760611AbZDCUR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:17:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757182AbZDCUR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:17:56 -0400
Date: Fri, 3 Apr 2009 13:14:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49D66C0E.5090301@garzik.org>
Message-ID: <alpine.LFD.2.00.0904031309500.4015@localhost.localdomain>
References: <1238758370.32764.5.camel@think.oraclecorp.com> <alpine.LFD.2.00.0904030804160.4130@localhost.localdomain> <49D66C0E.5090301@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Apr 2009, Jeff Garzik wrote:
>
> Yeah, it's a no-name SSD.
> 
> I've attached 'hdparm -I' in case anyone is curious.  It's from newegg.com, so
> nothing NDA'd or sekrit.

Hmm. Does it do ok on the "random write" test? There's a few non-intel 
controllers that are fine - apparently the newer samsung ones, and the one 
from Indilinx.

But I _think_ G.SKILL uses those horribly broken JMicron controllers. 
Judging by your performance numbers, it's the slightly fancier double 
controller version (ie basically an internal RAID0 of two identical 
JMicron controllers, each handling half of the flash chips).

Try a random write test. If it's the JMicron controllers, performance will 
plummet to a few tens of kilobytes per second.

			Linus
