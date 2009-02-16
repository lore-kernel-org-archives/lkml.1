Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbZBPUFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbZBPUFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZBPUE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:04:59 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:48667 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZBPUE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:04:59 -0500
Date: Mon, 16 Feb 2009 21:06:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Replace deprecated __initcall with device_initcall and fix whitespaces in kernel/kallsyms.c
Message-ID: <20090216200651.GB16721@uranus.ravnborg.org>
References: <ea11fea30902160824l22b10dcblc89c718015e156c8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea11fea30902160824l22b10dcblc89c718015e156c8@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 09:54:25PM +0530, Manish Katiyar wrote:
> Patch to fix coding style whitespace issues and replace __initcall
> with device_initcall
> 
> Errors as reported by checkpatch.pl :-
> Before:
> total: 14 errors, 14 warnings, 487 lines checked
> After :
> total: 0 errors, 11 warnings, 486 lines checked
> 
> Compile tested binary verified as :-
> Before:
>   text    data     bss     dec     hex filename
>    2405       4       0    2409     969 kernel/kallsyms.o
> After :
>   text	   data	    bss	    dec	    hex	filename
>    2405	      4	      0	   2409	    969	kernel/kallsyms.o
> 
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>

You did not fix the "spaces around operators" issue I showed you.
And you have not done an intellegent conding-style cleanup as
described in another mail by Ingo(*).

(*) As your changelog does not say so I assume you did no do it.

So please try again and be more critical this time and try to address
the issues raised.

Thanks,
	Sam
