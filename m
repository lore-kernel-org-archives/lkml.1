Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbYBWJVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbYBWJVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 04:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYBWJVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 04:21:17 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:40339 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753927AbYBWJVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 04:21:14 -0500
Message-ID: <47BFE468.70104@linux.vnet.ibm.com>
Date: Sat, 23 Feb 2008 14:46:24 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: menage@google.com, xemul@openvz.org, balbir@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] ResCounter: Use read_uint in memory controller
References: <20080221203518.544461000@menage.corp.google.com> <20080221205525.349180000@menage.corp.google.com> <47BE4FB5.5040902@linux.vnet.ibm.com> <20080223000426.adf5c75a.akpm@linux-foundation.org>
In-Reply-To: <20080223000426.adf5c75a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 22 Feb 2008 09:59:41 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> menage@google.com wrote:
>>> Update the memory controller to use read_uint for its
>>> limit/usage/failcnt control files, calling the new
>>> res_counter_read_uint() function.
>>>
>>> Signed-off-by: Paul Menage <menage@google.com>
>>>
>> Hi, Paul,
>>
>> Looks good, except for the name uint(), can we make it u64(). Integers are 32
>> bit on both ILP32 and LP64, but we really read/write 64 bit values.
>>
> 
> yup, I agree.  Even though I don't know what ILP32 and LP64 are ;)

ILP32 and LP64 are programming models. They stand for Integer, Long, Pointer 32
bit for 32 bit systems and Long, Pointer 64 bit for 64 bit systems (which
implies integers are 32 bit).

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
