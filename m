Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbXJ1EVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbXJ1EVl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 00:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbXJ1EVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 00:21:34 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38647 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXJ1EVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 00:21:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Dump stack during sysctl registration failure
References: <200710271757.l9RHvcY9021751@harpo.it.uu.se>
	<20071027183453.GB9816@martell.zuzino.mipt.ru>
	<20071027184328.GC9816@martell.zuzino.mipt.ru>
Date: Sat, 27 Oct 2007 22:20:39 -0600
In-Reply-To: <20071027184328.GC9816@martell.zuzino.mipt.ru> (Alexey Dobriyan's
	message of "Sat, 27 Oct 2007 22:43:28 +0400")
Message-ID: <m1r6jfrht4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> On Sat, Oct 27, 2007 at 10:34:53PM +0400,  wrote:
>> --- a/arch/powerpc/kernel/idle.c
>> +++ b/arch/powerpc/kernel/idle.c
>> @@ -122,7 +122,7 @@ static ctl_table powersave_nap_sysctl_root[] = {
>>  	{
>>  		.ctl_name	= CTL_KERN,
>>  		.procname	= "kernel",
>> -		.mode		= 0755,
>> +		.mode		= 0555,
>
> Speaking of...
>
>
> [PATCH] Dump stack during sysctl registration failure
>
> Let's make immediately obvious from where sysctl comes from and
> messages itself more noticeable.
>
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

For ambiguous cases like directories this looks like a serious
help.

