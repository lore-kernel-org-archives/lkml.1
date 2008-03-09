Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbYCIRdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbYCIRdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYCIRdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:33:08 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:57336 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbYCIRdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:33:07 -0400
Date: Sun, 09 Mar 2008 11:33:02 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SWNCQ should be enabled by default
In-reply-to: <47D41E58.6030303@dunaweb.hu>
To: Zoltan Boszormenyi <zboszor@dunaweb.hu>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       prakash@punnoor.de, pchen@nvidia.com, kluo@nvidia.com
Message-id: <47D41F4E.7050403@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <47CFE29E.8080107@dunaweb.hu> <47D41E58.6030303@dunaweb.hu>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zoltan Boszormenyi wrote:
> Ping. Now with patch.
> 
> Zoltan Boszormenyi írta:
>> Hi,
>>
>> the patch is already upstream, thanks for that.
>> I am using it without any problems. Currently I am
>> using kernel-2.6.24.3-12.fc8 from the updates-testing
>> repository of Fedora 8. I had to add
>>
>> options scsi_hostadapter1 swncq=1
>> options sata_nv swncq=1
>>
>> before upgrading to get it enabled.
>> Can we enable it by default for 2.6.25?
>> It's completely independent from ADMA and its problems.
>> E.g. my machine has 8GB memory now, no problems at all.
>>
>> Best regards,
>> Zoltán Böszörményi
> 

I'll ACK this, at least for -mm..
