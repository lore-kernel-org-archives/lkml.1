Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZC0WHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZC0WHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZC0WGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:06:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42003 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbZC0WGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:06:51 -0400
Message-ID: <49CD4DDF.3000001@garzik.org>
Date: Fri, 27 Mar 2009 18:06:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain> <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 27 Mar 2009, Jeff Garzik wrote:
>> On the other side of the coin, major desktop apps Firefox and Thunderbird
>> already use it:  Firefox uses sqlite  [...]
> 
> You do know that Firefox had to _disable_ fsync() exactly because not 
> disabling it was unacceptable? That whole "why does firefox stop for 5 
> seconds" thing created too many bug-reports.
> 
>> So, arguments about "people should..." aside, existing desktops apps _do_
>> fsync and we get to deal with the bad performance :/
> 
> No they don't. Read up on it. Really.

What is in Fedora 10 and Debian lenny's iceweasel both definitely sync 
to disk, as of today, according to my own tests.

I'm talking about what's in real world user's hands today, not some 
hoped-for future version in developer CVS somewhere, depending on build 
options and who knows what else...

	Jeff



