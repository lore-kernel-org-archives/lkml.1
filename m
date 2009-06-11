Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbZFKHtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbZFKHtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 03:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbZFKHtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 03:49:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54717 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbZFKHtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 03:49:11 -0400
Message-ID: <4A30B751.9050809@cn.fujitsu.com>
Date: Thu, 11 Jun 2009 15:50:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       yinghai@kernel.org
Subject: Re: [PATCH 2/2] sched: use slab in cpupri_init()
References: <Pine.LNX.4.64.0906110846330.2617@melkki.cs.Helsinki.FI>	 <4A309FDD.4030804@cn.fujitsu.com> <1244705062.17483.9.camel@penberg-laptop>	 <4A30B422.8080109@cn.fujitsu.com> <1244705842.17483.14.camel@penberg-laptop>
In-Reply-To: <1244705842.17483.14.camel@penberg-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Thu, 2009-06-11 at 15:37 +0800, Li Zefan wrote:
>> cpupri_init() is marked as __init_refok, because it calls
>> alloc_bootmem_cpumask_var() not because init_rootdomain()
>> has the tag. Now this patch removes this function call,
>> so the tag is no long needed.
> 
> Aah, OK, makes sense. Care to send a patch to Ingo once we have this
> thing merged?
> 

OK. Actually it's me that added it. ;)
(see db2f59c8c9b315f2b88b1dac159b988c6009034d)
