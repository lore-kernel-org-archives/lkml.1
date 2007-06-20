Return-Path: <linux-kernel-owner+w=401wt.eu-S1763068AbXFTKmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763068AbXFTKmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 06:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbXFTKmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:42:39 -0400
Received: from calisto.ae.poznan.pl ([150.254.37.3]:56023 "EHLO
	calisto.ae.poznan.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466AbXFTKmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:42:38 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2007 06:42:37 EDT
Message-ID: <4679030E.5010205@ae.poznan.pl>
Date: Wed, 20 Jun 2007 12:35:58 +0200
From: =?ISO-8859-2?Q?Maciej_So=B3tysiak?= <maciej.soltysiak@ae.poznan.pl>
Organization: =?ISO-8859-2?Q?Pozna=F1_University_of_Economics?=
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.14 NFS related oops
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > I'm running 2.6.21.5 now with slab debugging on, here's what I got 
about
 > > slab corruption:
 > >
 > > Slab corruption: skbuff_head_cache start=ef287b78, len=164
 > > Redzone: 0x5a2cf071/0x5a2cf071.
 > > Last user: [<c031710c>](kfree_skbmem+0x3c/0x90)
 > > 090: 6b 6b 6b 6b 6b 63 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
 > > Single bit error detected. Probably bad RAM.
 > > Run memtest86+ or a similar memory test tool.
 > > Prev obj: start=ef287ac8, len=164
 > > Redzone: 0x170fc2a5/0x170fc2a5.
 > > Last user: [<c031798b>](__alloc_skb+0x2b/0x100)
 > > 000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 > > 010: 00 00 00 00 e0 71 e6 ef 00 00 00 00 00 00 00 00
 > > Next obj: start=ef287c28, len=164
 > > Redzone: 0x170fc2a5/0x170fc2a5.
 > > Last user: [<c031798b>](__alloc_skb+0x2b/0x100)
 > > 000: 84 d0 85 c5 84 d0 85 c5 04 d0 85 c5 2c 0a 73 46
 > > 010: 6f cd 09 00 00 00 00 00 01 00 00 00 08 e5 72 ee
 > >
 > > How probable is that it is really a bad memory issue?
 > > Does this report say anything about which RAM chip I should
 > > investigate/replace ? I have 1x512MB+1x256MB
 > >
 > > Best Regards,
 > > Maciej
 >
 > I'd try doing as suggested above: run memtest86 on the computer for a
 > couple of hours and see what it tells you. That should hopefully give
 > you enough information to figure out which chips need replacing.

I am also getting BAD CRC on the disk that holds my swap partition.
I was wondering if slab debugging could say I have slab corruption not 
because
my RAM chips are bad, but because SWAP has bad blocks ? And that the
whole problem might be swap disk related not ram related.

 > Cheers
 >   Trond
Regards,
Maciej

