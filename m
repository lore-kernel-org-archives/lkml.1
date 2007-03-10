Return-Path: <linux-kernel-owner+w=401wt.eu-S1767671AbXCJAyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767671AbXCJAyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 19:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXCJAyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 19:54:45 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:63955 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbXCJAym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 19:54:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17906.460.163289.191563@smtp.charter.net>
Date: Fri, 9 Mar 2007 19:54:36 -0500
From: "John Stoffel" <john@stoffel.org>
To: Greg KH <greg@kroah.com>
Cc: John Stoffel <john@stoffel.org>, linux-usb-devel@lists.sourceforge.net,
       oneukum@suse.de,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc3 - oops on remove of USB dongle
In-Reply-To: <20070309212401.GB8629@kroah.com>
References: <17905.32741.244785.543626@smtp.charter.net>
	<20070309212401.GB8629@kroah.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Greg> On Fri, Mar 09, 2007 at 10:40:21AM -0500, John Stoffel wrote:
>> 
>> Hi all,
>> 
>> I've just compiled and installed 2.6.21-rc3 on my Dual CPU Dell
>> Precision 610MT system.  Dual 550mhz Xeon, 768mb of RAM.  Mix of SCSI,
>> ATA drives.  I'm using the new ATA_ drivers for my PATA disks.  
>> 
>> After booting, I pulled my seldom used USB->serial device from the
>> system to toss in my bag to bring to work.  It's a Belkin F5U109
>> dongle.  I noticed the following oops:

Greg> Ugh, I have a fix for this in my tree, I'll send it to Linus in
Greg> a few hours.

Greg> sorry for taking so long with this...

No problem.  Oliver Neukum sent me a pair of patches to try (appended
below) and they seem to have done the trick just fine now.  I can
plug/unplug the device without any more oopses.

Hopefully this will make it into 2.6.21-rc4

Cheers,
John

