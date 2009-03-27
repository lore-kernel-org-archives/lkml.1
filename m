Return-Path: <linux-kernel-owner+w=401wt.eu-S1761155AbZC0WcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761155AbZC0WcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZC0WcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:32:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbZC0WcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:32:06 -0400
Date: Fri, 27 Mar 2009 15:25:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
 <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
 <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Linus Torvalds wrote:
> 
> The values are: 0 = off, 1 = normal, 2 = full.

Of course, I don't actually know that "off" really means "never fsync". It 
may be that it only cuts down on the number of fsync's. I do know that 
firefox with the original defaults ("fsync everywhere") was totally 
unusable, and that got fixed.

But maybe it got fixed to "only pauses occasionally" rather than "every 
single page load brings everything to a screetching halt".

Of course, your browsing history database is an excellent example of 
something you should _not_ care about that much, and where performance is 
a lot more important than "ooh, if the machine goes down suddenly, I need 
to be 100% up-to-date". Using fsync on that thing was just stupid, even 
regardless of any ext3 issues.

		Linus
