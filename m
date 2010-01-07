Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635Ab0AGC4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab0AGC4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950Ab0AGC4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:56:39 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:29180 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab0AGC4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:56:38 -0500
Message-ID: <4B454D01.6070401@oracle.com>
Date: Thu, 07 Jan 2010 10:54:57 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mike Christie <michaelc@cs.wisc.edu>
CC: open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: iscsi warning in 2.6.33-rc2
References: <4B3AE891.5010508@oracle.com> <4B44E790.9070800@cs.wisc.edu>
In-Reply-To: <4B44E790.9070800@cs.wisc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B454D59.01FE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It works. Thanks.

Tested-by: Tao Ma <tao.ma@oracle.com>

Mike Christie wrote:
> On 12/29/2009 11:43 PM, Tao Ma wrote:
>> Hi all,
>>     I met with this warning when using iscsi with the 2.6.33-rc2.
>>
>> ------------[ cut here ]------------
>> WARNING: at drivers/scsi/libiscsi_tcp.c:996
> 
> ....
> 
>>
>> The other thing I can confirm is that I didn't meet with such problem in
>> 2.6.32-rc8.
>>
> 
> Sorry for the late reply. I am just getting back.
> 
> I think this is due to the kfifo changes that got merged recently.
> 
> For the iscsi side if there is nothing in the r2tqueue fifo at this time 
> it is fine. It just means that there is nothing to process, so I think 
> that the warn on should just not have been added.
> 
> Could you try the attached patch? I have only compile tested it. I am 
> starting up some testing for the patch and the other fifo changes that 
> got merged now.
> 
