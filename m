Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab0CIGes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:34:48 -0500
Received: from swm.pp.se ([212.247.200.143]:42163 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab0CIGen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:34:43 -0500
Date: Tue, 9 Mar 2010 07:34:41 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Tejun Heo <tj@kernel.org>
cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
In-Reply-To: <4B947393.2050002@kernel.org>
Message-ID: <alpine.DEB.1.10.1003090733330.9819@uplift.swm.pp.se>
References: <4B947393.2050002@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010, Tejun Heo wrote:

>  http://ata.wiki.kernel.org/index.php/ATA_4_KiB_sector_issues

Excellent summary.

> C-2. Windows XP depends on the traditional partition layout.

Is this really true? WD ships their EARS drives with an alignment tool 
that as far as I can understand, moves the partition so
it's aligned to 4KiB:

http://www.wdc.com/en/products/advancedformat/

So an XP fresh install (including letting XP partition the drive) will be 
misaligned, but if you clone xp onto a properly aligned partition (or run 
the tool and let it move the partition), it'll be ok. So saying that XP 
"depends" on traditional partition layout might be a bit of a streth?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
