Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbZC2VMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbZC2VMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 17:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbZC2VMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 17:12:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753711AbZC2VMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 17:12:42 -0400
Date: Sun, 29 Mar 2009 14:07:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Xavier Bestel <xavier.bestel@free.fr>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090329211655.630b8e1e@the-village.bc.nu>
Message-ID: <alpine.LFD.2.00.0903291354480.3994@localhost.localdomain>
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
 <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
 <20090327183214.2e73b6a3@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0903271138220.3994@localhost.localdomain> <20090327190056.3b699e89@lxorguk.ukuu.org.uk> <1238318146.11869.1.camel@badjo> <20090329211655.630b8e1e@the-village.bc.nu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Mar 2009, Alan Cox wrote:
> 
> Yep and twenty years on software hasn´t improved

I really think you're gilding the edges of those old memories. The 
software 20 years ago wasn't that great. I'd say it was on the whole a 
whole lot crappier than it is today.

It's just that we have much higher expectations, and our problem sizes 
have grown a _lot_ faster than rotating disk latencies have improved. 
People didn't worry about having a hundred megs of dirty data and doing an 
'fsync' twenty years ago. Even on big hardware (if you _had_ a hundred 
megs of dirty data you didn't worry about latencies of a few seconds), 
never mind in the Linux world.

This particular problem really largely boils down to "average memory 
capacity has expanded a _lot_ more than harddisk speeds have gone up".

			Linus
