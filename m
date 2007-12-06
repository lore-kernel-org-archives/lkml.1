Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbXLFQDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbXLFQDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbXLFQDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:03:07 -0500
Received: from ns.suse.de ([195.135.220.2]:53379 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbXLFQDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:03:06 -0500
Date: Thu, 6 Dec 2007 17:02:14 +0100 (CET)
From: Bernhard Kaindl <bk@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: remote debugging via FireWire * __fast__ firedump!
In-Reply-To: <200712040839.39984.ak@suse.de>
Message-ID: <alpine.LNX.0.9999-openSUSE-1.0712061649000.21849@jbgna.fhfr.qr>
References: <200702101242.48467.ak@suse.de> <45CDCDCD.5000609@s5r6.in-berlin.de> <alpine.DEB.0.9999.0712040426100.3769@vic.ffii.org> <200712040839.39984.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007, Andi Kleen wrote:
>
>> I have just had the guts to explore __fast__ memory dumping over
>> firewire for full-system dumps [...]
>
> Unfortunately it won't work for >3GB or so AFAIK.

Yes we seem to be limited to 4GB mostly, with 3G mem hole, it's 3GB.

>> Afterwards, the victim was dead (I excluded the low MB of memory,
>> so something else must have caused this), at least the start of
>
> Did you run into the PCI memory hole below 4GB?

Thanks, that was it most likely. I checked and haw that I did
read a 32MB reserved area just below 2GB.

> I suppose the best way would be to require a System.map and
> then read e820.nr_map/e820.map[] and only dump real memory.

Yes, good idea!
Bernhard
