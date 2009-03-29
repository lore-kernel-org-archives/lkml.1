Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbZC2BZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbZC2BZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 21:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZC2BZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 21:25:22 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47107 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbZC2BZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 21:25:21 -0400
Message-ID: <49CECDEB.7040704@garzik.org>
Date: Sat, 28 Mar 2009 21:24:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: david@lang.hm
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain> <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <alpine.DEB.1.10.0903281726100.22577@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0903281726100.22577@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> ted's suggestion (in his blog) to tweak fsync to 'misbehave' when laptop 
> mode is enabled (only pushing data out to disk when the disk is awake 
> anyway, or the time has hit) would really work well for most users. 
> servers (where you have the data integrity fsync useage) don't use 
> laptop mode. desktops could use 'laptop mode' with a delay of 0.5 or 1 
> second and get prety close the the guarentee that users want without a 
> huge performance hit.

The existential struggle is overall amusing:

Application writers start using userland transactional databases for 
crash recovery and consistency, and in response, OS writers work to 
undercut the consistency guarantees currently provided by the OS.


More seriously, if we get sqlite, db4 and a few others behaving sanely 
WRT fsync, you cover a wide swath of apps all at once.

I absolutely agree that db4, sqlite and friends need to be smarter in 
the case of laptop mode or overall power saving.

	Jeff


