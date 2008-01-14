Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbYANIMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbYANIMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYANIMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 03:12:08 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:54858
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbYANIMH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 03:12:07 -0500
Message-Id: <478B277B.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 14 Jan 2008 08:12:28 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Adrian Bunk" <bunk@kernel.org>
Cc: <len.brown@intel.com>, "Andi Kleen" <ak@suse.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] introduce __cpuinitconst
References: <47873D40.76E4.0078.0@novell.com>
 <20080111210044.GA17276@does.not.exist>
In-Reply-To: <20080111210044.GA17276@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- 2.6.24-rc7-initconst.orig/include/linux/init.h
>> +++ 2.6.24-rc7-initconst/include/linux/init.h
>> @@ -269,11 +269,13 @@ void __init parse_early_param(void);
>>  #ifdef CONFIG_HOTPLUG_CPU
>>  #define __cpuinit
>>  #define __cpuinitdata
>> +#define __cpuinitconst const
>>  #define __cpuexit
>>  #define __cpuexitdata
>>  #else
>>  #define __cpuinit	__init
>>  #define __cpuinitdata __initdata
>> +#define __cpuinitconst __initdata
>>  #define __cpuexit __exit
>>  #define __cpuexitdata	__exitdata
>>  #endif
>
>__cpuinitconstdata ?
>
>I know it's a bit long, but it would be more logically when looking at 
>the other ones.

I considered it, but didn't use it because as you say it's a bit long and
additionally nothing but data can be 'const'.

Jan

