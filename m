Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbYAEAsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbYAEAsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 19:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYAEArx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 19:47:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36966 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbYAEArw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 19:47:52 -0500
Message-ID: <477ED3B5.7070009@zytor.com>
Date: Fri, 04 Jan 2008 16:47:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Querying the bios from booted linux kernel?
References: <200801041913.54030.gene.heskett@gmail.com>
In-Reply-To: <200801041913.54030.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Greetings;
> 
> Is there a utility that can query the motherboard bios and get a list of the 
> drives it can see?
> 
> Likewise, for the bios extension contained on a pny sata card with a Silicon 
> Image chipset on it?
> 
> I'm trying to cobble up a way for linux to boot from the drive on this sata 
> card, so that the F8 install is completely separated from the FC6 install on 
> a pata drive connected to the mainboard.
> 

No, but if you configure in EDD support (and don't disable it), then the 
kernel will do so on your behalf during early boot.

Unfortunately, it is not trivial to produce a mapping from EDD data to 
real-life disks.  Your best bet is if the disks have an MBR signature, 
in which case the EDD code will capture those; you can then correlate 
them to real disks.

	-hpa
