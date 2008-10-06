Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYJFUsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYJFUsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 16:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbYJFUsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 16:48:25 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56471 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbYJFUsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 16:48:24 -0400
Message-ID: <48EA79AC.8090705@linux.vnet.ibm.com>
Date: Mon, 06 Oct 2008 15:48:44 -0500
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Adam Litke <agl@us.ibm.com>, linuxppc-dev <linuxppc-dev@ozlabs.org>,
       Adam Litke <agl@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] properly reserve in bootmem the lmb reserved regions
 that cross numa nodes
References: <48E23D6C.4030406@linux.vnet.ibm.com> <1222789675.13978.14.camel@localhost.localdomain> <7E5B6DFB-F9DE-4929-8A4F-8011BF817017@kernel.crashing.org> <48EA31D5.70609@linux.vnet.ibm.com> <1DA7FAFA-0708-4CFC-B721-B09A29F45B3F@kernel.crashing.org>
In-Reply-To: <1DA7FAFA-0708-4CFC-B721-B09A29F45B3F@kernel.crashing.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
>
> On Oct 6, 2008, at 10:42 AM, Jon Tollefson wrote:
>
>> Kumar Gala wrote:
>>> Out of interest how to do you guys represent NUMA regions of memory in
>>> the device tree?
>>>
>>> - k
>> Looking at the source code in numa.c I see at the start of
>> do_init_bootmem() that parse_numa_properties() is called.  It appears to
>> be looking at memory nodes and getting the node id from it.  It gets an
>> associativity property for the memory node and indexes that array with a
>> 'min_common_depth' value to get the node id.
>>
>> This node id is then used to setup the active ranges in the
>> early_node_map[].
>>
>> Is this what you are asking about?  There are others I am sure who know
>> more about it then I though.
>
> I was wondering if this was documented anywhere (like in sPAPR)?
>
> - k
I see some information on it in section "C.6.6".

Jon

