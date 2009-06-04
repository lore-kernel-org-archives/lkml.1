Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZFDDIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZFDDIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 23:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZFDDII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 23:08:08 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:31701 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbZFDDIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 23:08:07 -0400
Message-ID: <4A2739E4.9090606@chelsio.com>
Date: Wed, 03 Jun 2009 20:05:08 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: ben@decadent.org.uk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH net-next 2/2] cxgb3: Add Aeluros 2020 phy support
References: <20090529075829.30669.41488.stgit@speedy5>	<20090601105349.GF3051@decadent.org.uk>	<4A27311D.7070400@chelsio.com> <20090603.200050.146284422.davem@davemloft.net>
In-Reply-To: <20090603.200050.146284422.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2009 03:06:28.0031 (UTC) FILETIME=[73DACCF0:01C9E4C1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Divy Le Ray <divy@chelsio.com>
> Date: Wed, 03 Jun 2009 19:27:41 -0700
>
>   
>> In a boot over the network environment, request_firmware() will not be
>> granted
>> access to the file system.
>>     
>
> This is not true, first of all.  It can be built into the kernel image
> via CONFIG_FIRMWARE_IN_KERNEL.
>   

I missed this one.

> Second of all, there is initrd.
>
> There are NO EXCUSES for not using request_firmware() at this point.
>   

Fair enough. I'll fix the driver to use request_firmware().

Cheers,
Divy
