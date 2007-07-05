Return-Path: <linux-kernel-owner+w=401wt.eu-S1761942AbXGEUEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942AbXGEUEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761345AbXGEUEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:04:04 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:50976 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbXGEUEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:04:02 -0400
Message-ID: <468D4E8A.40602@linux.vnet.ibm.com>
Date: Thu, 05 Jul 2007 13:03:22 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@osdl.org>, Pavel Emelianov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [-mm PATCH 4/7] Memory controller memory accounting
References: <20070704222108.17702.40293.sendpatchset@balbir-laptop> <20070704222203.17702.37327.sendpatchset@balbir-laptop> <468D3C6C.8060900@linux.vnet.ibm.com>
In-Reply-To: <468D3C6C.8060900@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan wrote:
>>
>> +	if (mem_container_charge(page, mm)) {
> 
> Minor correction.  The above line should be
> 
> if (mem_container_charge(new, mm)) {
> 
> to avoid compilation error.
> 
> --Vaidy
> 
> [snip]

Thanks, Vaidy,

Patch incorporated.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
