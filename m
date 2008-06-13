Return-Path: <linux-kernel-owner+w=401wt.eu-S1761691AbYFMJhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761691AbYFMJhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 05:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbYFMJhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 05:37:39 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:58788 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754317AbYFMJhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 05:37:38 -0400
Message-ID: <48523FC5.4040900@linux.vnet.ibm.com>
Date: Fri, 13 Jun 2008 15:07:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: righi.andrea@gmail.com
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH -mm] PAGE_ALIGN(): correctly handle 64-bit values on 32-bit
 architectures
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>	<20080521152948.15001.39361.sendpatchset@localhost.localdomain>	<4850070F.6060305@gmail.com>	<20080611121510.d91841a3.akpm@linux-foundation.org>	<485032C8.4010001@gmail.com>	<20080611134323.936063d3.akpm@linux-foundation.org>	<485055FF.9020500@gmail.com>	<20080611155530.099a54d6.akpm@linux-foundation.org>	<4850BE9B.5030504@linux.vnet.ibm.com>	<4850E3BC.308@gmail.com> <20080612020235.29a81d7c.akpm@linux-foundation.org> <485156B8.5070709@gmail.com>
In-Reply-To: <485156B8.5070709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> I've tested the following patch on a i386 box with my usual .config and
> everything seems fine. I also tested allmodconfig and some randconfig
> builds and
> I've not seen any evident error.
> 
> I'll repeat the tests tonight on a x86_64. Other architectures should be
> tested
> as well...
> 
> Patch is against 2.6.25-rc5-mm3.

Hi, Andrea,

CC'ing linux-arch. I have a power box, but it's busy. I'll try and test your
patch on it as soon as I can get hold of it.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
