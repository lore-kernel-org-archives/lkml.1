Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbYIQVnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbYIQVnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbYIQVnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:43:04 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51338 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbYIQVnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:43:02 -0400
Message-ID: <48D17917.5080700@cs.helsinki.fi>
Date: Thu, 18 Sep 2008 00:39:35 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix declaration of cgroup_mm_owner_callbacks
References: <20080915190638.99E613D6952@localhost> <20080917142714.a822ac1a.akpm@linux-foundation.org> <48D176EA.9040304@linux.vnet.ibm.com>
In-Reply-To: <48D176EA.9040304@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Andrew Morton wrote:
>> On Mon, 15 Sep 2008 12:06:38 -0700 (PDT)
>> menage@google.com (Paul Menage) wrote:
>>
>>> Fix declaration of cgroup_mm_owner_callbacks()
>>>
>>> The choice of real/dummy declaration for cgroup_mm_owner_callbacks()
>>> shouldn't be based on CONFIG_MM_OWNER, but on
>>> CONFIG_CGROUPS. Otherwise kernel/exit.c fails to compile when
>>> something other than a cgroups controller selects CONFIG_MM_OWNER
>>>
>> Being too lazy to go back and find out what "something" is, I assumed
>> that this isn't needed in 2.6.27.
> 
> We don't have anything using CONFIG_MM_OWNER in 2.6.27, so we should be OK
> pushing this to 2.6.28 (Pekka plans to use it for revoke* calls).

Oh, I am already using it:

http://git.kernel.org/?p=linux/kernel/git/penberg/linux-2.6.git;a=commitdiff;h=3201a05704afafd7c61b204b7f0c2a9ddcf935d0

Still debugging some ext3 corruption problems, though :-)

> Pekka, Paul do you agree?

Yes, agreed.
