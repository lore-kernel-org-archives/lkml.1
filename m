Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbZDCS7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbZDCS7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 14:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbZDCS73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 14:59:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34122 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756868AbZDCS73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:59:29 -0400
Message-ID: <49D65C80.4080003@garzik.org>
Date: Fri, 03 Apr 2009 14:59:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Mark Lord <lkml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tytso@mit.edu, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090401225737.GC3797@csclub.uwaterloo.ca> <49D6214A.9030204@rtr.ca> <20090403151648.GJ3795@csclub.uwaterloo.ca>
In-Reply-To: <20090403151648.GJ3795@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Fri, Apr 03, 2009 at 10:46:34AM -0400, Mark Lord wrote:
>> My Myth box here was running 2.6.18 when originally set up,
>> and even back then it still took *minutes* to delete large files.
>> So that part hasn't really changed much in the interim.
>>
>> Because of the multi-minute deletes, the distro shutdown scripts
>> would fails, and power off the box while it was still writing
>> to the drives.  Ouch.
>>
>> That system has had XFS on it for the past year and a half now,
>> and for Myth, there's no reason not to use XFS.  It's great!
> 
> Mythtv has a 'slow delete' option that I believe works by slowly
> truncating the file.  Seems they believe that ext3 is bad at handling
> large file deletes, so they try to spread out the pain.  I don't remember
> if that option is on by default or not.  I turned it off.

It's pretty painful for super-large files with lots of metadata.

	Jeff



