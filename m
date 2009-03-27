Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbZC0Vv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbZC0Vv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbZC0Vvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:51:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751428AbZC0Vvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:51:49 -0400
Date: Fri, 27 Mar 2009 14:46:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49CD2C47.4040300@garzik.org>
Message-ID: <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain>
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
 <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
 <49CD2C47.4040300@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Jeff Garzik wrote:
> 
> On the other side of the coin, major desktop apps Firefox and Thunderbird
> already use it:  Firefox uses sqlite  [...]

You do know that Firefox had to _disable_ fsync() exactly because not 
disabling it was unacceptable? That whole "why does firefox stop for 5 
seconds" thing created too many bug-reports.

> So, arguments about "people should..." aside, existing desktops apps _do_
> fsync and we get to deal with the bad performance :/

No they don't. Read up on it. Really.

Guys, I don't understand why you even argue. I've been complaining about 
fsync() performance for the last five years or so. It's taken you a long 
time to finally realize, and you still don't seem to "get it".

PEOPLE LITERALLY REMOVE 'fsync()' CALLS BECAUSE THEY ARE UNACCEPTABLE FOR 
USERS.

It really is that simple.

			Linus
