Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbXKNMiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbXKNMiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 07:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbXKNMiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 07:38:14 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:41355 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbXKNMiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 07:38:13 -0500
Message-ID: <473AEC32.3020802@grupopie.com>
Date: Wed, 14 Nov 2007 12:38:10 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Kallsyms Should Prefer Non Weak Symbols
References: <20071113191355.GA1125@Krystal> <20071113191537.GB1125@Krystal>
In-Reply-To: <20071113191537.GB1125@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
>>> [...]
>>> kallsyms returns the first symbol encountered, even though it is weak,
>>> when it should in fact return sys_ni_syscall.
>>> Is it a concern for anyone else out there ? Would it make sense to fix
>>> it ?
>> I don't know if it is a concern, but if we're going to fix it, we should
>> probably do it in "scripts/kallsyms" by providing a list that is already
>> sorted according to "address, weakness".
>>
>> This way the run-time kernel keeps the current behavior, without any
>> overhead. Something along the lines of the attached patch (just compile
>> tested).
>>
>> However, this is an area where we've had problems in the past with some
>> architectures giving different results between passes, and then any change
>> to the symbol order might make the problem worse and make the build process
>> fail with a "Inconsistent kallsyms data" error message.
>>
>> So, if someone wants to use this, it should go through -mm for a while,
>> first.
>>
>> It applies on top of 2.6.24-rc2-git3.
> 
> Please use this reply with correct CC list for further discussion.

I've been wanting to send this as a proper patch request email, but I 
just hadn't found the time to do it, and then our mail server just went 
berserk and I lost 5 days of LKML :P

I think the patch is ok as it is, but a nice message explaining what it 
does and why would be nice for the changelog. So, I'll post a new 
message with a nice description for inclusion in -mm today.

Sorry for the delay,

-- 
Paulo Marques - www.grupopie.com

"Very funny Scotty. Now beam up my clothes."
