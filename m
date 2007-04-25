Return-Path: <linux-kernel-owner+w=401wt.eu-S1030930AbXDYUqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030930AbXDYUqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993094AbXDYUqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:46:20 -0400
Received: from foo.birdnet.se ([213.88.146.6]:39433 "EHLO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030930AbXDYUqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:46:20 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2007 16:46:19 EDT
Message-ID: <20070425203937.11718.qmail@cdy.org>
Date: Wed, 25 Apr 2007 22:39:37 +0200
From: Peter Stuge <stuge-linux-pcmcia@cdy.org>
To: linux-pcmcia@lists.infradead.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ide-cs: recognize 2GB CompactFlash from Transcend
Mail-Followup-To: linux-pcmcia@lists.infradead.org,
	lkml <linux-kernel@vger.kernel.org>
References: <44c9a2b88950e3848d2c4e457641eb9b@kernel.crashing.org> <D7810733513F4840B4EBAAFA64D9C6A4012D5C9F@stgw002a.ww002.siemens.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D7810733513F4840B4EBAAFA64D9C6A4012D5C9F@stgw002a.ww002.siemens.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 11:27:09AM +0200, Aeschbacher, Fabrice wrote:
> I'm not sure which correct values must be assigned to the 3th and
> 4th parameters (here: 0x709b1bf1, 0xf54a91c8). Anyway, the patch is
> working with these values. Tested on arch=mips.
> 
> +       PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1,
> 0xf54a91c8),

According to /usr/src/linux/Documentation/pcmcia/devicetable.txt and
crc32hash.c the 4th parameter should be 0x969aa4f2.


//Peter
