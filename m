Return-Path: <linux-kernel-owner+w=401wt.eu-S932585AbXBJPOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbXBJPOv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 10:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932590AbXBJPOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 10:14:51 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34936 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585AbXBJPOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 10:14:50 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45CDE14C.4040203@s5r6.in-berlin.de>
Date: Sat, 10 Feb 2007 16:14:20 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Bernhard Kaindl <bk@suse.de>, discuss@x86-64.org,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: remote debugging via FireWire
References: <200702101242.48467.ak@suse.de>	<45CDCDCD.5000609@s5r6.in-berlin.de> <200702101502.59431.ak@suse.de>
In-Reply-To: <200702101502.59431.ak@suse.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Saturday 10 February 2007 14:51, Stefan Richter wrote:
>> Could be handled via linux1394-2.6.git, although a
>> different channel where the actual users of this facility watch would
>> IMO be more appropriate.
> 
> It's more related to arch code than firewire, so I thought i would
> handle it. But you can too if you want. It definitely needs much
> more review anyways.

It's better you do it. I don't know anything about the specifics of
early initialization. Just Cc linux1394-devel on submission so that we
can have a look at the OHCI-1394 related bits.

Using linux1394-2.6.git could only be helpful if more code sharing
between ohci1394.c and ohci1394_early.c would be desired. That's
questionable though, given the rather small size of ohci1394_early.c.

>> A mostly unrelated note: A simple to set up remote-dmesg utility would
>> be nice to have on the terminal side.
> 
> ftp://ftp.firstfloor.org/pub/ak/firescope/

Thanks, I wasn't aware that firescope actually does fill this gap.
-- 
Stefan Richter
-=====-=-=== --=- -=-=-
http://arcgraph.de/sr/
