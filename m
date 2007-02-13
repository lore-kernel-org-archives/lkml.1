Return-Path: <linux-kernel-owner+w=401wt.eu-S1750726AbXBMNx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750726AbXBMNx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 08:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbXBMNx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 08:53:58 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:42104 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbXBMNx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 08:53:58 -0500
Message-ID: <45D1C2E9.4070803@citd.de>
Date: Tue, 13 Feb 2007 14:53:45 +0100
From: Matthias Schniedermeyer <ms@citd.de>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "Martin A. Fink" <fink@mpe.mpg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
References: <200702121502.17130.fink@mpe.mpg.de> <200702131129.19270.fink@mpe.mpg.de> <45D1AE13.9000504@citd.de> <200702131349.05428.fink@mpe.mpg.de>
In-Reply-To: <200702131349.05428.fink@mpe.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin A. Fink wrote:
>> The needed total bandwidth may be to high and at least the incoming part via 
> GigE may have serious overhead.
>> 150MB/s in via (at least 2) GigE, without Zero-Copy there is another 150MB/s 
> memory to memory.
>> Then there is the next 150MB/s memory to the discs, without Zero-Copy there 
> also another 150MB/s memory to memory.
>> In total that's 300MB/s to 600MB/s without any processing.
> 
> I dont understand your calculation: from 3 GE ports come around 50 MB/each. 
> These altogether 150MB/s have to be copied to memory. From there they will be 
> copied to disk. So we talk about 2x150 MB/s running through my system. That 
> is less than 2 PCIe lanes can handle... And there are more than 2 lanes 
> between north and south bridge....

It may be that the TCP/IP-Stack has to copy the data around. But someone that knows the inner workings would have to answer this.
That may also depend on the used NIC.

Also the data doesn't appear 'en bloc', but arrives over a period of time, so you have more or less big "gaps" in the processing.

Especially the "gaps" can considerably lower total achievable bandwidth.

A little naive fallacy (According to dict.leo.org a translation for: Milchmädchenrechnung):
You get a package of work every (say) 1ms and you (say) need .2ms for processing, shoveling and writing to disc.
Then there is no way you can saturate more than 1/5 of total theoretical bandwidth, because 80% of the time you are waiting for more work to come.



-- 
Real Programmers consider "what you see is what you get" to be just as
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated,
cryptic, powerful, unforgiving, dangerous.

