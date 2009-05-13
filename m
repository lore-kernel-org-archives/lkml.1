Return-Path: <linux-kernel-owner+w=401wt.eu-S1760978AbZEMQzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbZEMQzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbZEMQzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:55:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36477 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178AbZEMQzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:55:40 -0400
Message-ID: <4A0AFB7D.2080105@zytor.com>
Date: Wed, 13 May 2009 09:55:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Extend test_and_set_bit() test_and_clean_bit() to
 64 bits in X86_64
References: <1242202647-32446-1-git-send-email-sheng@linux.intel.com> <4A0AF2DA.2020404@zytor.com>
In-Reply-To: <4A0AF2DA.2020404@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Sheng Yang wrote:
>> This fix 44/45 bit width memory can't boot up issue. The reason is
>> free_bootmem_node()->mark_bootmem_node()->__free() use test_and_clean_bit() to
>> clean node_bootmem_map, but for 44bits width address, the idx set bit 31 (43 -
>> 12), which consider as a nagetive value for bts.
>>
>> This patch applied to tip/mm.
> 
> Hi Sheng,
> 
> Could you try the attached patch instead?
> 
> 	-hpa
> 

Sorry, wrong patch entirely... here is the right one.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

