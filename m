Return-Path: <linux-kernel-owner+w=401wt.eu-S1764767AbXLPWsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764767AbXLPWsw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 17:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbXLPWsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 17:48:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40162 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755AbXLPWso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 17:48:44 -0500
Message-ID: <4765AB32.9040608@zytor.com>
Date: Sun, 16 Dec 2007 14:48:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/4] x86: Final unification of local_{32|64}.h
References: <1197806669.3749.44.camel@brick> <20071216153158.GA891@elte.hu>
In-Reply-To: <20071216153158.GA891@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
>> No differences except for the defintion of local_add_return on X86_64. 
>> The X86_32 version is just fine as it is protected with ifdef 
>> CONFIG_M386 so use it directly.
> 
> thanks, i've applied your 4 patches to x86.git.
> 
> btw., now that we have a single unified file, it might make sense to fix 
> these checkpatch complaints:
> 
>   total: 10 errors, 1 warnings, 257 lines checked
> 
> in case you are interested ;-)
> 

Please pull them pending revision, they're broken (macros don't expand 
inside strings...)

	-hpa
