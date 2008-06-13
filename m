Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbYFMJsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbYFMJsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 05:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYFMJsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 05:48:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54632 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbYFMJsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 05:48:08 -0400
Message-ID: <485241AE.4030300@cn.fujitsu.com>
Date: Fri, 13 Jun 2008 17:45:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: righi.andrea@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       yamamoto@valinux.co.jp, menage@google.com, linux-kernel@vger.kernel.org,
       xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH -mm] PAGE_ALIGN(): correctly handle 64-bit values on 32-bit
 architectures
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>	<20080521152948.15001.39361.sendpatchset@localhost.localdomain>	<4850070F.6060305@gmail.com>	<20080611121510.d91841a3.akpm@linux-foundation.org>	<485032C8.4010001@gmail.com>	<20080611134323.936063d3.akpm@linux-foundation.org>	<485055FF.9020500@gmail.com>	<20080611155530.099a54d6.akpm@linux-foundation.org>	<4850BE9B.5030504@linux.vnet.ibm.com>	<4850E3BC.308@gmail.com> <20080612020235.29a81d7c.akpm@linux-foundation.org> <485156B8.5070709@gmail.com> <48523FC5.4040900@linux.vnet.ibm.com>
In-Reply-To: <48523FC5.4040900@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Andrea Righi wrote:
>> I've tested the following patch on a i386 box with my usual .config and
>> everything seems fine. I also tested allmodconfig and some randconfig
>> builds and
>> I've not seen any evident error.
>>
>> I'll repeat the tests tonight on a x86_64. Other architectures should be
>> tested
>> as well...
>>
>> Patch is against 2.6.25-rc5-mm3.
> 
> Hi, Andrea,
> 
> CC'ing linux-arch. I have a power box, but it's busy. I'll try and test your
> patch on it as soon as I can get hold of it.
> 
> 

It passes allmodconfig and a randconfig build on ia64, but I have no more access
to the machine to do more test.
