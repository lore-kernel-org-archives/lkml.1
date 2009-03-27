Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbZC0WZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbZC0WZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZC0WZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:25:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711AbZC0WZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:25:08 -0400
Date: Fri, 27 Mar 2009 15:19:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49CD4DDF.3000001@garzik.org>
Message-ID: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
 <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
 <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Jeff Garzik wrote:
>
> What is in Fedora 10 and Debian lenny's iceweasel both definitely sync to
> disk, as of today, according to my own tests.

Hmm. Go to "about:config" and check your "toolkit.storage.synchronous" 
setting.

It _should_ say

	default integer 0

and that is what it says for me (yes, on Fedora 10).

The values are: 0 = off, 1 = normal, 2 = full.

If you don't have that "toolkit.storage.synchronous" entry, that means 
that you have an older version of firefox-3. And if you have some other 
value, it either means somebody changed it, or that Fedora is shipping 
with multiple different versions (the "official" Firefox source code 
defaults to 1, I think, but they suggested distributions change the 
default to 0).

		Linus
