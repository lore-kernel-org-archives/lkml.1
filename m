Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbZDPCn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbZDPCn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbZDPCns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:43:48 -0400
Received: from ip-64-139-1-69.sjc.megapath.net ([64.139.1.69]:51464 "EHLO
	ip-64-139-1-69.sjc.megapath.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966AbZDPCns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:43:48 -0400
X-Greylist: delayed 1598 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Apr 2009 22:43:47 EDT
X-Mailer: exmh version 2.4 06/23/2000 with nmh-1.0.4
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       hmurray@megapathdsl.net
From: Hal Murray <hmurray@megapathdsl.net>
Subject: Re: USB storage no-boot regression (bisected) 
In-Reply-To: Message from Arjan van de Ven <arjan@infradead.org> 
   of "Wed, 15 Apr 2009 18:32:13 PDT." <20090415183213.7962d929@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 15 Apr 2009 19:17:07 -0700
Message-Id: <20090416021708.6A713BCE2@ip-64-139-1-69.sjc.megapath.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> .... who would boot their server from a USB stick for production use?

I've worked on a project that was doing that.  Think of embedded computing 
rather than a typical box in a server farm.

If you want to do something slightly more complicated than monitor 
temperature, it's sometimes simpler/cheaper to trim down a real OS than it is 
to build up an environment that has everything you need, especially if you 
want to do any networking.  With enough RAM, LInux runs fine without a disk, 
and if you don't need a GUI, "enough RAM" isn't much by modern standards.

There are several distributions targeted at running out of RAM after booting 
from an USB thumb drive or Compact Flash or CD or whatever.

Google for >Linux on a Stick< or >Puppy Linux< for a few starters.


-- 
These are my opinions, not necessarily my employer's.  I hate spam.



