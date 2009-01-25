Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbZAYRNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbZAYRNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 12:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZAYRNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 12:13:36 -0500
Received: from torrent.cc.mcgill.ca ([132.206.27.49]:59794 "EHLO
	torrent.cc.mcgill.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZAYRNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 12:13:36 -0500
Subject: Re: Memory not being reported
From: David Ronis <ronis@ronispc.chem.mcgill.ca>
Reply-To: ronis@ronispc.chem.mcgill.ca
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <497AD339.2030602@shaw.ca>
References: <1232658295.3455.7.camel@ronispc.chem.mcgill.ca>
	 <497AD339.2030602@shaw.ca>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Department of Chemistry, McGill University
Date: Sun, 25 Jan 2009 12:13:24 -0500
Message-Id: <1232903604.5855.5.camel@montroll.chem.mcgill.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
X-PMX-Version: 5.4.2.338381, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2008.11.25.160724
X-McGill-WhereFrom: Internal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this is a 64bit capable box.  Nonetheless, there are only
4G of memory, not more, and I still see 3G of it.

David



On Sat, 2009-01-24 at 02:37 -0600, Robert Hancock wrote:
> David Ronis wrote:
> > I'm running 2.6.28.1 on an i686 (slackware-12.1 for the most part) box.
> > I recently added some extra memory, expanding from 2Gb to 4.  Everything
> > works as expected except that not all of the memory seems to be seen.
> > 
> > free returns:
> > 
> >              total       used       free     shared    buffers
> > cached
> > Mem:       3374860    2099504    1275356          0      86612
> > 1032024
> > -/+ buffers/cache:     980868    2393992
> > Swap:       497972          0     497972
> > 
> > 
> > and cat /proc/meminfo gives:
> > 
> > MemTotal:        3374860 kB
> > MemFree:         1199184 kB
> > Buffers:           86816 kB
> > Cached:          1036240 kB
> > SwapCached:            0 kB
> > Active:          1375864 kB
> > 
> > etc.
> > 
> > On the other hand, user-space tools like lshw show the 4 1Gb DIMMS as
> > does the BIOS configuration boot menu.
> > 
> > One suspicion is that the configure option CONFIG_HIGHMEM4G=y
> > should be unset and the CONFIG_HIGHMEM64G  should be.
> 
> Yes, it should be. However, if your chipset doesn't support remapping 
> memory above the 4GB mark (some don't, and this is needed in this case 
> because various IO areas use up some of the address space below 4GB) 
> then it won't be possible to make use of any of that RAM.
> 
> Note that when running with more than 4GB of RAM it's generally 
> preferable to run a 64-bit kernel if the machine supports it.
> 
> > 
> > Any help would be appreciated, as would a separate CC since I don't
> > subscribe to the list.
> > 
> > Thanks in advance
> > 
> > David
> > 
> 
