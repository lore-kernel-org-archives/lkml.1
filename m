Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbYFBJsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbYFBJsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbYFBJs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:48:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42423 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757133AbYFBJs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:48:26 -0400
Message-ID: <4843C1E0.3080900@garzik.org>
Date: Mon, 02 Jun 2008 05:48:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Pavel Machek <pavel@ucw.cz>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Theodore Tso <tytso@mit.edu>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
References: <20080508161008.59361de5@appleyard>	<20080527030854.GC7515@mit.edu>	<20080527143202.4bab5bf0@appleyard>	<20080527225926.GE6843@mit.edu>	<20080527163251.04054a74@appleyard>	<20080531080015.GG5405@ucw.cz>	<4842F5A8.9020708@garzik.org>	<20080602080440.25fc663c@core>	<4843A4A7.3020809@garzik.org> <20080602092225.26db9b5b@core>
In-Reply-To: <20080602092225.26db9b5b@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> The key requirement is per-port control.  Ideally via hdparm or another 
>> userspace tool, but kernel command line (module options) or sysfs would 
>> be just fine too.  And agreed, the minimal you need is simply 1/0 for 
>> the port's policy.
> 
> We don't need it per port Jeff, you are being quite silly here. Right now
> its permanently foo=0 for all ports and nobody has suffered anything too
> horrible so being able to turn it off for all ports is clearly quite
> sufficient for the neat future.

Er, huh?  foo=0 means hotplug continues to work on the unused ports. 
Nobody has suffered because we default to enabling all the goodies.

	Jeff


