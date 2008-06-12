Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYFLGOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYFLGOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYFLGOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:14:04 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:60513 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYFLGOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:14:02 -0400
Message-ID: <4850BE9B.5030504@linux.vnet.ibm.com>
Date: Thu, 12 Jun 2008 11:43:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: righi.andrea@gmail.com, linux-mm@kvack.org, skumar@linux.vnet.ibm.com,
       yamamoto@valinux.co.jp, menage@google.com, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 2/4] Setup the memrlimit controller (v5)
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain> <20080521152948.15001.39361.sendpatchset@localhost.localdomain> <4850070F.6060305@gmail.com> <20080611121510.d91841a3.akpm@linux-foundation.org> <485032C8.4010001@gmail.com> <20080611134323.936063d3.akpm@linux-foundation.org> <485055FF.9020500@gmail.com> <20080611155530.099a54d6.akpm@linux-foundation.org>
In-Reply-To: <20080611155530.099a54d6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> #define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)
> 
> ?
> 
> afaict ALIGN() tries to do the right thing, and if it doesn't, we
> should fix ALIGN().
> 

That should do the right thing, provided there are no duplicate ALIGN defintions
elsewhere

kernel.h has


#define ALIGN(x,a)              __ALIGN_MASK(x,(typeof(x))(a)-1)
#define __ALIGN_MASK(x,mask)    (((x)+(mask))&~(mask))

Which seems like the correct thing, since we use typeof(x) for (a) - 1.



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
