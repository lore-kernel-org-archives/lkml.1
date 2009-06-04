Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbZFDCcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbZFDCcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 22:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZFDCcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 22:32:07 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:32961 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZFDCcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 22:32:06 -0400
Message-ID: <4A27311D.7070400@chelsio.com>
Date: Wed, 03 Jun 2009 19:27:41 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH net-next 2/2] cxgb3: Add Aeluros 2020 phy support
References: <20090529075823.30669.28885.stgit@speedy5> <20090529075829.30669.41488.stgit@speedy5> <20090601105349.GF3051@decadent.org.uk>
In-Reply-To: <20090601105349.GF3051@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2009 02:29:00.0421 (UTC) FILETIME=[382CBB50:01C9E4BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:
> On Fri, 2009-05-29 at 00:58 -0700, Divy Le Ray wrote:
> [...]
>   
>> +	/* TWINAX EDC firmware */
>> +	static u16 twinax_edc[] = {
>> +		0xd800, 0x4009,
>> +		0xd801, 0x2fff,
>> +		0xd802, 0x300f,
>> +		0xd803, 0x40aa,
>> +		0xd804, 0x401c,
>>     
> [...]
>
> Use request_firmware() please.
>
> Ben.
>
>   

Hi Ben,

Sorry for the late reply.

The registers controlling the electronic dispersion compensation
need to be programmed based on the module inserted when the phy gets out 
of reset.

In a boot over the network environment, request_firmware() will not be 
granted
access to the file system. The EDC registers setup would be problematic.

Cheers,
Divy
 

