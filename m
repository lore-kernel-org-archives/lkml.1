Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbZC0PUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbZC0PUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 11:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbZC0PUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 11:20:39 -0400
Received: from fornax.pixelized.ch ([88.198.8.169]:58274 "EHLO
	fornax.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbZC0PUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 11:20:39 -0400
Message-ID: <49CCEEBB.6010807@cateee.net>
Date: Fri, 27 Mar 2009 16:20:27 +0100
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090327032301.GN6239@mit.edu> <20090327034705.GA16888@srcf.ucam.org> <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org>
In-Reply-To: <20090327145156.GB24819@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Fri, Mar 27, 2009 at 07:24:38AM -0400, Theodore Tso wrote:
>> On Fri, Mar 27, 2009 at 06:21:14AM +0000, Matthew Garrett wrote:
>>> (It could be argued that most relevant Unices implemented fsync() even 
>>> before then, so its status in POSIX was broadly irrelevant. The obvious 
>>> counterargument is that most relevant Unix filesystems ensure that data 
>>> is written before a clobbering rename() is carried out, so POSIX is 
>>> again not especially releant)
>> Nope, not true.  Most relevant Unix file systems sync'ed data blocks
>> on a 30 timer, and metadata on 5 second timers.  They did *not* force
>> data to be written before a clobbering rename() was carried you;
>> you're rewriting history when you say that; it's simply not true.
>> Rename was atomic *only* where metadata was concerned, and all the
>> talk about rename being atomic was because back then we didn't have
>> flock() and you built locking primitives open(O_CREAT) and rename();
>> but that was only metadata, and that was only if the system didn't
>> crash.
> 
> No, you're missing my point. The other Unix file systems are irrelevant. 
> The number of people running them and having any real risk of system 
> crash is small, and they're the ones with full system backups anyway.


Are you telling us that the "Linux compatible" really means
"Linux compatible, but only on ext3, only on x86,
only on Ubuntu, only Gnome or KDE [1]"?
If a program crashes on other setups, is it not a
problem of the program but of the environment?

sigh
	cate


[1]Yes, I just see a installation script that expect one of the
two environment.

