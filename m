Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbZCFCAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbZCFCAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 21:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbZCFCAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 21:00:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:44539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbZCFCAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 21:00:19 -0500
Message-ID: <49B083AC.1070505@kernel.org>
Date: Fri, 06 Mar 2009 11:00:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [x86-tip] overflow in relocation type 11 val 39ffdd0e8690
References: <1236287654.3677.3.camel@localhost.localdomain>	 <20090305212535.GA13848@elte.hu> <1236288780.3677.9.camel@localhost.localdomain>
In-Reply-To: <1236288780.3677.9.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 01:59:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> On Thu, 2009-03-05 at 22:25 +0100, Ingo Molnar wrote:
>> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
>>
>>> On latest tip I am getting:
>>>
>>> [  124.169475] overflow in relocation type 11 val 39ffdd0e8690
>>> [  124.169508] `msr_debug' likely not compiled with -mcmodel=kernel
>>> [  146.582299] overflow in relocation type 11 val 39ffdd0e8690
>>> [  146.582299] `msr_debug' likely not compiled with -mcmodel=kernel
>>> [  836.653168] overflow in relocation type 11 val 39ffdd0e8690
>>> [  836.653201] `msr_debug' likely not compiled with -mcmodel=kernel
>>>
>>> But 1d10914bf2c8 was working fine.
> 
> No it is also not fine :( for percpu.
> 
>> That's a linker bug - Tejun Cc:-ed.
>>
> 
> Problem is basically with 64 bit percpu on 32 bit it is OK. Ahh, Here is
> the solution:
> 
> http://lkml.org/lkml/2009/3/3/129
> 
> because of commit 8ac83757149 of Tejun Heo.

Yeah, patchset almost ready.  Please wait a bit more.

Thanks.

-- 
tejun
