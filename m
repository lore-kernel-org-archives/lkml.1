Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbZDCXi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbZDCXi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 19:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbZDCXir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 19:38:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44850 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756193AbZDCXiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 19:38:46 -0400
Date: Fri, 3 Apr 2009 19:35:55 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090403233555.GA24143@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jeff Garzik <jeff@garzik.org>, Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1238758370.32764.5.camel@think.oraclecorp.com> <alpine.LFD.2.00.0904030804160.4130@localhost.localdomain> <49D66C0E.5090301@garzik.org> <alpine.LFD.2.00.0904031309500.4015@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904031309500.4015@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 01:14:00PM -0700, Linus Torvalds wrote:
 > But I _think_ G.SKILL uses those horribly broken JMicron controllers. 
 > Judging by your performance numbers, it's the slightly fancier double 
 > controller version (ie basically an internal RAID0 of two identical 
 > JMicron controllers, each handling half of the flash chips).
 > 
 > Try a random write test. If it's the JMicron controllers, performance will 
 > plummet to a few tens of kilobytes per second.

I got the 64GB variant of Jeff's g-skill SSD.  When I first got it,
I ran aio-stress on it.  The numbers from the smaller blocksize tests
are pitiful.  To the extent that after running for 24hrs, I ctrl-c'd
the test.  Really, really abysmal.

	Dave

