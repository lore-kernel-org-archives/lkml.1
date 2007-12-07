Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXLGVnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXLGVnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 16:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbXLGVnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 16:43:43 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:53994 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271AbXLGVnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 16:43:42 -0500
Message-ID: <4759BE88.3020702@linux.vnet.ibm.com>
Date: Sat, 08 Dec 2007 03:13:36 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <Pine.LNX.4.62.0712072229280.26862@pademelon.sonytel.be> <4759BCBA.7060800@linux.vnet.ibm.com>
In-Reply-To: <4759BCBA.7060800@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Geert Uytterhoeven wrote:
>> On Sat, 8 Dec 2007, Balbir Singh wrote:
>>> +	if (strstr(p, "fake="))
>>> +		cmdline = p + 5;	/* 5 is faster than strlen("fake=") */
>> Really? My gcc is smart enough to replace the `strlen("fake=")' by 5, even
>> without -O.
>>
> 
> Thanks for pointing that out, but I am surprised that a compiler would
> interpret library routines like strlen.
> 

I just tested it and it turns out that you are right. I'll go hunt to
see where gcc gets its magic powers from.

>> With kind regards,
>>
>> Geert Uytterhoeven
>> Software Architect
> 
> 


