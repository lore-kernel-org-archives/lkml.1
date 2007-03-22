Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbXCVCDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbXCVCDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 22:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbXCVCDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 22:03:07 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:25023 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbXCVCDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 22:03:06 -0400
Message-ID: <4601E3C5.5070103@chelsio.com>
Date: Wed, 21 Mar 2007 18:02:45 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.21 2/4] cxgb3 - Auto-load FW if mismatch detected
References: <20070318201006.16292.12877.stgit@localhost.localdomain> <20070321150706.9b916d79.akpm@linux-foundation.org>
In-Reply-To: <20070321150706.9b916d79.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Mar 2007 02:02:48.0129 (UTC) FILETIME=[307B4310:01C76C26]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 18 Mar 2007 13:10:06 -0700
> divy@chelsio.com wrote:
>
>   
>>  config CHELSIO_T3
>>          tristate "Chelsio Communications T3 10Gb Ethernet support"
>>          depends on PCI
>> +	select FW_LOADER
>>     
>
> Something has gone wrong with the indenting there.
>   

The added line is fine. The surrounding lines are not. They use white 
spaces.
I'll send a patch over the last series to use tabs in drivers/net/Kconfig.

Cheers,
Divy
