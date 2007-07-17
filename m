Return-Path: <linux-kernel-owner+w=401wt.eu-S935911AbXGQTiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935911AbXGQTiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762083AbXGQThw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:37:52 -0400
Received: from opinicus.com ([24.73.193.242]:51154 "EHLO thing2.opinicus.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761867AbXGQThv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:37:51 -0400
Message-ID: <469D1A65.8030704@opinicus.com>
Date: Tue, 17 Jul 2007 15:37:09 -0400
From: William Montgomery <william@opinicus.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Subject: Re: e100 PCI bridge problem
References: <4697B85B.4040902@opinicus.com>	<m33azrt5a6.fsf@maximus.localdomain> <46995998.70706@opinicus.com> <m3d4yuczqw.fsf@maximus.localdomain> <469D0A81.3000001@opinicus.com> <469D1093.9070801@intel.com>
In-Reply-To: <469D1093.9070801@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:

>> 00:1e.0 PCI bridge: Intel Corp. 82801BA/CA/DB/EB/ER Hub interface to 
>> PCI Bridge (rev 82) (prog-if 00 [Normal decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR+ FastB2B-
>>         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast 
>> >TAbort- <TAbort- <MAbort- >SERR- <PERR+
>
>
> PERR+ set... not good - this certainly will cause major issues
>
I know it sounds that way based on the definition (Detected parity error 
on hub side), however I have two other identical systems that have been 
running fine for months - with this same bit set - only they use an 
Adaptec ANA-64044 (4 port card - 10/100 fast ethernet - unfortunately 
discontinued). 

It seems the Pericom PCI to PCI bridge is having a problem talking to 
the LAN controllers behind the Hint bridge.

