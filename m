Return-Path: <linux-kernel-owner+w=401wt.eu-S934965AbXJQRZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934965AbXJQRZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760340AbXJQRZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:25:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57184 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760147AbXJQRZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:25:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4716452F.4080408@s5r6.in-berlin.de>
Date: Wed, 17 Oct 2007 19:23:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Gabor Gombas <gombasg@sztaki.hu>
CC: david@lang.hm, Matthew Wilcox <matthew@wil.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Rob Landley <rob@landley.net>,
       David Newall <david@davidnewall.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
References: <200710141836.55211.rob@landley.net> <4712FE33.3000400@s5r6.in-berlin.de> <200710150426.04924.rob@landley.net> <20071015160800.GA324@parisc-linux.org> <47139F15.7050702@s5r6.in-berlin.de> <Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm> <20071016111911.30a18e12@the-village.bc.nu> <Pine.LNX.4.64.0710161238140.6995@asgard.lang.hm> <20071016195432.GA31306@parisc-linux.org> <Pine.LNX.4.64.0710161302460.6995@asgard.lang.hm> <20071017094838.GB18035@boogie.lpds.sztaki.hu>
In-Reply-To: <20071017094838.GB18035@boogie.lpds.sztaki.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabor Gombas wrote:
> On Tue, Oct 16, 2007 at 01:55:07PM -0700, david@lang.hm wrote:
>> why is this any different from the external enclosures? they have always 
>> appeared as the type of device that connects them to the motherboard, (and 
>> even with SCSI, there are some controllers that don't generate sdX devices)
> 
> In the past enclosures supported only one kind of connector so this
> assumption was fine. But nowadays an external disk may have several
> connectors (like USB, Firewire and eSata). Why should the disk's name
> depend on what type of cable did I manage to grab first? It is the
> _same_ disk regardless of the cable type.

Yes, but even udev won't give you one and the same symlink to the disk's
device file then.¹  There isn't a persistent unique target/unit property
which all of these transports have in common.

The only thing that could be common in the best case is the symlink to
the partition's device file, based on filesystem UUID or filesystem label.

¹) unless you write your own rule specific to this on particular enclosure
-- 
Stefan Richter
-=====-=-=== =-=- =---=
http://arcgraph.de/sr/
