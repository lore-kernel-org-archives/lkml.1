Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbZDWPId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbZDWPId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759488AbZDWPH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:07:59 -0400
Received: from mga07.intel.com ([143.182.124.22]:58462 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759477AbZDWPH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:07:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,236,1239001200"; 
   d="scan'208";a="135036172"
Message-ID: <49F08447.9040003@linux.intel.com>
Date: Thu, 23 Apr 2009 08:07:51 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, akpm@osdl.org
Subject: Re: [PATCH] Eliminate thousands of warnings in WARN_ON with gcc 3.2
 build
References: <20090422221134.GA1753@basil.nowhere.org> <20090423120219.GA23479@cmpxchg.org> <20090423122327.GN13896@one.firstfloor.org> <20090423143859.GA20453@cmpxchg.org> <20090423151024.GO13896@one.firstfloor.org>
In-Reply-To: <20090423151024.GO13896@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thu, Apr 23, 2009 at 04:38:59PM +0200, Johannes Weiner wrote:
>>> +void warn_slowpath_null(const char *file, int line)
>>> +{
>>> +	warn_slowpath_fmt(file, line, (const char *) { 0 });
>>> +}
>>> +EXPORT_SYMBOL(warn_slowpath_null);
>> I would WTF here without knowing the warning.  Can you add a comment?
>>
>> Otherwise, Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Ok version with comment.

Makes sense if we plan to keep gcc 3.2 supported; if we plan to drop it then we shouldn't bother.

Anyway

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

