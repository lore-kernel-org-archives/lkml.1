Return-Path: <linux-kernel-owner+w=401wt.eu-S939172AbXFHM4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939172AbXFHM4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 08:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937318AbXFHM4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 08:56:07 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:63628 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937143AbXFHM4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 08:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=MdYnfcWhd3TUO4k4y08MlZLP7xAbjspBQ2ezlPkcgt0zqJnOdWcZ+UCLsYoVOlsUwdhThhnERWEJQnlUasOQ5IKWdkVY8ib5Oxr/BtUExWN95F1WYS4O8u+hej1qBghwl/OvsCHo9SiKfhzgK/Gam1oPSa22oBuLMD84FNODaVA=
Message-ID: <466951DE.9070004@gmail.com>
Date: Fri, 08 Jun 2007 21:55:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Florin Iucha <florin@iucha.net>
CC: Robert Hancock <hancockr@shaw.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: spurious completions during NCQ?
References: <fa.Nigm+GFAuAW+QzfgqTUfmHJoFfU@ifi.uio.no> <4666C477.1070603@shaw.ca> <20070607120430.GB30661@iucha.net>
In-Reply-To: <20070607120430.GB30661@iucha.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florin Iucha wrote:
> On Wed, Jun 06, 2007 at 08:28:07AM -0600, Robert Hancock wrote:
>>> This is on a Thinkpad T60 with 2 GB RAM, running Ubuntu 7.04 (kernel
>>> 2.6.20-16-generic).  No proprietary drivers (ok, maybe the Intel
>>> Wi-Fi - but that should not count).
>>>
>>> The laptop came with Windows but I blew that away - did I mess some
>>> thing up regarding HPA and its ilk?
>> It means the drive reported command tags were completed that were not 
>> outstanding. What kind of drive is this?
> 
> [   29.033142] ata1.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156
> 301488
> [   29.033146] ata1.00: ATA-7: HITACHI HTS541680J9SA00, SB2IC7EP, max UDMA/100
> [   29.033149] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [   29.034230] ata1.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156
> 301488

Please report the result of 'hdparm -I /dev/sda'.  We'll probably have
to blacklist it for NCQ.

-- 
tejun
