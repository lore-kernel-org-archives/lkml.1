Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYF0EMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYF0EMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 00:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750723AbYF0EMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 00:12:21 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:53649 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750803AbYF0EMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 00:12:20 -0400
Message-ID: <48646899.10407@linux.vnet.ibm.com>
Date: Fri, 27 Jun 2008 09:42:09 +0530
From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       ego@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com,
       davej@codemonkey.org.uk
Subject: Re: [BUG] While changing the cpufreq governor, kernel hits a bug
 in workqueue.c
References: <485F8028.1070302@linux.vnet.ibm.com> <87y74w41fp.fsf@skyscraper.fehenstaub.lan> <4860BB8E.2070505@linux.vnet.ibm.com> <87tzfh2t5l.fsf@skyscraper.fehenstaub.lan> <48638906.4090308@linux.vnet.ibm.com> <48639A40.8090203@linux.vnet.ibm.com>
In-Reply-To: <48639A40.8090203@linux.vnet.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nageswara R Sastry wrote:
Hi,
>> =======================================================
>> [ INFO: possible circular locking dependency detected ]
>> 2.6.25.7.cpufreq_patch #2
>> -------------------------------------------------------
[...]

> While running the script I observed no stack trace but sysfs hang for a 
> particular file like scaling_governor under cpufreq for a particular cpu 
> (this cpu is varying). In the following run I experienced with cpu4.
> 
> cat /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
> 
> The above command is not giving any result and it won't be coming out 
> after pressing ctrl+c or ctrl+z


Applied both the patches and it seems working fine - no stack trace, but 
the above "mentioned circular locking dependency and sysfs file hang" 
are existing.

Thanks
Regards
R.Nageswara Sastry
