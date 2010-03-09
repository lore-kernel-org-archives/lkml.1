Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab0CIKMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 05:12:47 -0500
Received: from relay.ppgk.com.pl ([80.53.243.36]:31953 "EHLO relay.ppgk.com.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab0CIKMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 05:12:43 -0500
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 05:12:42 EST
X-PPGK-Scanned: amavisd-new 2.6.4 (20090625) at ppgk.com.pl
Message-ID: <4B961D8F.3010500@ziu.info>
Date: Tue, 09 Mar 2010 11:06:07 +0100
From: Michal Soltys <soltys@ziu.info>
Organization: Luftbrandzlung
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Mikael Abrahamsson <swmike@swm.pp.se>
CC: Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <alpine.DEB.1.10.1003090733330.9819@uplift.swm.pp.se>
In-Reply-To: <alpine.DEB.1.10.1003090733330.9819@uplift.swm.pp.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Abrahamsson wrote:
> On Mon, 8 Mar 2010, Tejun Heo wrote:
> 
>>  http://ata.wiki.kernel.org/index.php/ATA_4_KiB_sector_issues
> 
> Excellent summary.
> 
>> C-2. Windows XP depends on the traditional partition layout.
> 
> Is this really true? WD ships their EARS drives with an alignment tool 
> that as far as I can understand, moves the partition so
> it's aligned to 4KiB:
> 

XP SP2 (or later) can boot from any place, including logical partitions 
(tested that recently). Most important thing is "hidden sectors" (recent 
chain.c32 can set that automatically through ntldr and/or sethidden 
options). No idea about pre-SP2 ; Win 2000 will not boot from "misaligned" 
(with reference to cylinder boundary) partition.

