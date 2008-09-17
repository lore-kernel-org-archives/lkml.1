Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbYIQV21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbYIQV21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYIQV2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:28:19 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46409 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbYIQV2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:28:19 -0400
Message-ID: <48D175A4.7080309@cs.helsinki.fi>
Date: Thu, 18 Sep 2008 00:24:52 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix declaration of cgroup_mm_owner_callbacks
References: <20080915190638.99E613D6952@localhost> <20080917142714.a822ac1a.akpm@linux-foundation.org>
In-Reply-To: <20080917142714.a822ac1a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Something being the revokeat() patches I recently resurrected. So no, 
not for 2.6.27. :-)
