Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYIQVan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYIQVan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbYIQVag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:30:36 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:50926 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbYIQVaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:30:35 -0400
Message-ID: <48D176EA.9040304@linux.vnet.ibm.com>
Date: Wed, 17 Sep 2008 14:30:18 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix declaration of cgroup_mm_owner_callbacks
References: <20080915190638.99E613D6952@localhost> <20080917142714.a822ac1a.akpm@linux-foundation.org>
In-Reply-To: <20080917142714.a822ac1a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 15 Sep 2008 12:06:38 -0700 (PDT)
> menage@google.com (Paul Menage) wrote:
> 
>> Fix declaration of cgroup_mm_owner_callbacks()
>>
>> The choice of real/dummy declaration for cgroup_mm_owner_callbacks()
>> shouldn't be based on CONFIG_MM_OWNER, but on
>> CONFIG_CGROUPS. Otherwise kernel/exit.c fails to compile when
>> something other than a cgroups controller selects CONFIG_MM_OWNER
>>
> 
> Being too lazy to go back and find out what "something" is, I assumed
> that this isn't needed in 2.6.27.

We don't have anything using CONFIG_MM_OWNER in 2.6.27, so we should be OK
pushing this to 2.6.28 (Pekka plans to use it for revoke* calls).

Pekka, Paul do you agree?


-- 
	Balbir
