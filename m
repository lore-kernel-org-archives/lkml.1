Return-Path: <linux-kernel-owner+w=401wt.eu-S1761430AbZC1CTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430AbZC1CTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 22:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbZC1CTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 22:19:11 -0400
Received: from rtr.ca ([76.10.145.34]:37437 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224AbZC1CTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 22:19:10 -0400
Message-ID: <49CD891A.7030103@rtr.ca>
Date: Fri, 27 Mar 2009 22:19:06 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain> <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org>
In-Reply-To: <49CD7B10.7010601@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Linus Torvalds wrote:
>> Of course, your browsing history database is an excellent example of 
>> something you should _not_ care about that much, and where performance 
>> is a lot more important than "ooh, if the machine goes down suddenly, 
>> I need to be 100% up-to-date". Using fsync on that thing was just 
>> stupid, even 
> 
> If you are doing a ton of web-based work with a bunch of tabs or windows 
> open, you really like the post-crash restoration methods that Firefox 
> now employs.  Some users actually do want to checkpoint/restore their 
> web work, regardless of whether it was the browser, the window system or 
> the OS that crashed.
> 
> You may not care about that, but others do care about the integrity of 
> the database that stores the active FF state (Web URLs currently open), 
> a database which necessarily changes for each URL visited.
..

fsync() isn't going to affect that one way or another
unless the entire kernel freezes and dies.

Firefox locks up the GUI here from time to time,
but the kernel still flushes pages to disk,
and even more quickly when alt-sysrq-s is used.

Cheers
