Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYAXKjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYAXKjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 05:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYAXKjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 05:39:11 -0500
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:48306 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838AbYAXKjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 05:39:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAFb5l0c7pynT/2dsb2JhbAAIrzw
X-IronPort-AV: E=Sophos;i="4.25,243,1199626200"; 
   d="scan'208";a="39025406"
Message-ID: <47986AC0.8000806@niasdigital.com>
Date: Thu, 24 Jan 2008 21:38:56 +1100
From: Ben Nizette <bn@niasdigital.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] define empty unxlate_dev_mem_ptr on AVR32
References: <47972AD2.20801@niasdigital.com> <20080124112911.0b1592f4@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080124112911.0b1592f4@dhcp-252-066.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:
> On Wed, 23 Jan 2008 22:53:54 +1100
> Ben Nizette <bn@niasdigital.com> wrote:
> 
>>  /*
>> + * We just keep an empty definition of this around (a-la the asm-generic
>> + * implementation) to keep /dev/mem happy
>> + */
>> +#define unxlate_dev_mem_ptr(p, a) {}
> 
> Thanks, but this should be either
> 
> #define unxlate_dev_mem_ptr(p, a) do { } while (0)
> 
> or
> 
> static inline void unxlate_dev_mem_ptr(unsigned long phys, void *addr)
> {
> }
> 
> I prefer the latter.

Yeah I don't know what came over me; Mia culpa :-)

I prefer the latter too, though I think I was striving for consistency with the xlate_dev_mem_ptr #define.

--Ben
