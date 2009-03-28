Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbZC1PRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbZC1PRg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 11:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbZC1PRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 11:17:13 -0400
Received: from rtr.ca ([76.10.145.34]:47557 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758295AbZC1PRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 11:17:12 -0400
Message-ID: <49CE3F74.6090103@rtr.ca>
Date: Sat, 28 Mar 2009 11:17:08 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain> <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de>
In-Reply-To: <49CE35AE.1080702@s5r6.in-berlin.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The better solution seems to be the rather obvious one:

   the filesystem should commit data to disk before altering metadata.

Much easier and more reliable to centralize it there, rather than
rely (falsely) upon thousands of programs each performing numerous
performance-killing fsync's.

Cheers
