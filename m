Return-Path: <linux-kernel-owner+w=401wt.eu-S965076AbXBUDn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965076AbXBUDn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 22:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030223AbXBUDn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 22:43:57 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:62631 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965076AbXBUDn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 22:43:56 -0500
Date: Tue, 20 Feb 2007 21:43:36 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: High CPU usage with sata_nv
In-reply-to: <fa.PMqnzxUBiShkWV4h9SiztNIwYc0@ifi.uio.no>
To: Matthew Fredrickson <creslin@digium.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <htejun@gmail.com>
Message-id: <45DBBFE8.5080901@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.1OWRIIUBXsZOXflsGLA+7d4YCc0@ifi.uio.no>
 <fa.A0XBTh7eCfsh11d3AhMO71/4xQU@ifi.uio.no>
 <fa.fCm35VohC2wt9vlkg94Ru7me4ic@ifi.uio.no>
 <fa.qDqCne4pXntL0PolSS2j8t4py3g@ifi.uio.no>
 <fa.8TboLRab6f7zzIWFr/JPM6q04Zo@ifi.uio.no>
 <fa.PMqnzxUBiShkWV4h9SiztNIwYc0@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Fredrickson wrote:
> I have noticed something that might be related as well.  I am working on 
> a device driver that would have periodic data errors due to 
> exceptionally long interrupt handling latency.  I have come to the point 
> that I suspect that it's the sata_nv driver, and now that we can't do 
> the hdparm -u1 option for sata, it seems to be a bigger problem.

What kernel are you using? There were some complaints about latency 
problems (the ATA status register read taking a ridiculous amount of 
time to complete) on sata_nv previously, but 2.6.20 should eliminate 
that problem at least on nForce4 chipsets..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

