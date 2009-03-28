Return-Path: <linux-kernel-owner+w=401wt.eu-S1759911AbZC1Cpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911AbZC1Cpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 22:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbZC1CpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 22:45:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754224AbZC1CpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 22:45:14 -0400
Date: Fri, 27 Mar 2009 19:38:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mark Lord <lkml@rtr.ca>
cc: Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49CD8868.20807@rtr.ca>
Message-ID: <alpine.LFD.2.00.0903271928340.3994@localhost.localdomain>
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
 <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
 <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <49CD8868.20807@rtr.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Mark Lord wrote:
>
> Okay, I'll bite.  Exactly which version of FF has that variable?
> Cuz it ain't in the FF 3.0.8 that I'm running here.

I _thought_ it was there since rc2 of FF-3, but clearly there are odd 
things afoot. You're the second person to report it not there.

I'd suspect that I mistyped it, but I just cut-and-pasted it from my email 
to make sure. Maybe you did. What happens if you just write "sync" in the 
Filter: box? Nothing matches?

Do you see firefox pausing a lot under disk load? If you just add that 
"toolkit.storage.synchronous" value by hand (right-click in the preference 
window, do "New" -> "Integer"), and write it in as zero, does it change 
behavior?

		Linus
