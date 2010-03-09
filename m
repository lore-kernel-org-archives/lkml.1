Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab0CILrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 06:47:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:38876 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab0CILq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 06:46:57 -0500
Message-ID: <4B963513.1060508@kernel.org>
Date: Tue, 09 Mar 2010 20:46:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu,lockdep: implement and use is_static_percpu_address()
References: <24605.1268073053@localhost> <1268073831.4997.69.camel@laptop>	 <4B95AA4C.2030303@kernel.org> <4298.1268116039@localhost>	 <4B95EE4C.3020606@kernel.org>  <4B9610E5.4080805@kernel.org> <1268133942.4162.2.camel@twins> <4B963441.40000@kernel.org>
In-Reply-To: <4B963441.40000@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Mar 2010 11:46:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/09/2010 08:42 PM, Tejun Heo wrote:
>> So is_module_address() will only return true for static per-cpu module
>> storage, right?
> 
> Right, got confused there.  I'll update is_static_percpu_address() to
> test for reserved regions too.

Which I can't in straight forward manner because only the module code
knows the allocated address ranges on archs which don't require low
offset addresses for module static percpu symbols.  Seems like we'll
need to create is_module_percpu_address() or something.  I'll think
about it.

Thanks.

-- 
tejun
