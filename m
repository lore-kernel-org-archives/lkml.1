Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbYCISJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYCISJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 14:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbYCISI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 14:08:56 -0400
Received: from mail.dunaweb.hu ([81.17.184.3]:41760 "EHLO mail.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbYCISI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 14:08:56 -0400
Message-ID: <47D427B2.6020204@dunaweb.hu>
Date: Sun, 09 Mar 2008 19:08:50 +0100
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       prakash@punnoor.de, pchen@nvidia.com, kluo@nvidia.com
Subject: Re: SWNCQ should be enabled by default
References: <47CFE29E.8080107@dunaweb.hu> <47D41E58.6030303@dunaweb.hu> <47D41F4E.7050403@shaw.ca>
In-Reply-To: <47D41F4E.7050403@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock írta:
> Zoltan Boszormenyi wrote:
>> Ping. Now with patch.
>>
>> Zoltan Boszormenyi írta:
>>> Hi,
>>>
>>> the patch is already upstream, thanks for that.
>>> I am using it without any problems. Currently I am
>>> using kernel-2.6.24.3-12.fc8 from the updates-testing
>>> repository of Fedora 8. I had to add
>>>
>>> options scsi_hostadapter1 swncq=1
>>> options sata_nv swncq=1
>>>
>>> before upgrading to get it enabled.
>>> Can we enable it by default for 2.6.25?
>>> It's completely independent from ADMA and its problems.
>>> E.g. my machine has 8GB memory now, no problems at all.
>>>
>>> Best regards,
>>> Zoltán Böszörményi
>>
>
> I'll ACK this, at least for -mm..

Thanks. On the other hand, the meat of the SWNCQ patch
had its exposure in -mm, there were no problem reports...


