Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbZBBRt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbZBBRt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757330AbZBBRtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:49:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47489 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321AbZBBRtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:49:45 -0500
Message-ID: <4987321A.1020404@zytor.com>
Date: Mon, 02 Feb 2009 09:49:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org
Subject: Re: [git-pull -tip] fix headers_check warnings
References: <1233593765.3244.14.camel@localhost.localdomain>	 <20090202172159.GA7479@localhost> <1233595855.28370.1.camel@localhost.localdomain>
In-Reply-To: <1233595855.28370.1.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
>>
>> Hi Jaswinder,
>>
>> it seems we have a clash here :) I thought this part
>> was just dropped out
>>
>> 	http://lkml.org/lkml/2009/1/14/461
>>
>> and Peter had been applying it on tip:x86/header-fixes
>>
>> 	http://lkml.org/lkml/2009/1/14/549
>>
>> but maybe it's just lost...
> 
> No, you cannot remove sys_arch_prctl otherwise you will get sparse
> warning like this:
> 
>   CHECK   arch/x86/kernel/process_64.c
> arch/x86/kernel/process_64.c:833:6: warning: symbol 'sys_arch_prctl' was not declared. Should it be static?
> 

Perhaps we can just move this prototype to <asm/syscalls.h>.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

