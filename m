Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbZDQTPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbZDQTPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZDQTPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:15:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40392 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZDQTOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:14:41 -0400
Message-ID: <49E8D51D.70400@garzik.org>
Date: Fri, 17 Apr 2009 15:14:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] AHCI updates: Marvell AHCI PATA works;	pata_marvell
 fate?
References: <20090417023949.GA14469@havoc.gtf.org> <20090417105031.607a771e@lxorguk.ukuu.org.uk> <20090417180316.GA7134@sci.fi>
In-Reply-To: <20090417180316.GA7134@sci.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ville Syrjälä wrote:
> On Fri, Apr 17, 2009 at 10:50:31AM +0100, Alan Cox wrote:
>>> Marvell PATA on 6121 and similar chips should also work, but that hasn't
>>> yet been tested.  Here's the full list of what still needs testing:
>>>
>>> - master + slave devices
>>> - ATAPI
>>> - 6121 (6123? others?)
>> LBA48
>>
>>
>>> Also, there is the open question of how to deal with pata_marvell
>>> co-existence
>> I think for the moment make PATA support by AHCI a config option and as
>> soon as we trust it we can get rid of the option and of pata_marvell.
> 
> How does this relate to 6101 which is a PATA only controller? Would that
> continue to use pata_marvell or does this new stuff support such things
> too?

I'm pretty sure 6101 will behave similarly to 6121, but have not verified.

	Jeff



