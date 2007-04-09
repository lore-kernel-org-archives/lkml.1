Return-Path: <linux-kernel-owner+w=401wt.eu-S965749AbXDIPpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965749AbXDIPpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965778AbXDIPpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:45:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:54322 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965749AbXDIPpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:45:03 -0400
Date: Mon, 9 Apr 2007 08:45:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [PATCH 1/2] Clean up asm-x86_64/bugs.h
Message-Id: <20070409084557.28748317.randy.dunlap@oracle.com>
In-Reply-To: <4617D339.3080801@goop.org>
References: <4617D339.3080801@goop.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Apr 2007 10:22:01 -0700 Jeremy Fitzhardinge wrote:

> Most of asm-x86_64/bugs.h is code which should be in a C file, so put it there.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> 
> ---
>  arch/x86_64/kernel/Makefile      |    3 ++-
>  arch/x86_64/kernel/bugs.c        |   28 ++++++++++++++++++++++++++++
>  include/asm-x86_64/alternative.h |    1 +
>  include/asm-x86_64/bugs.h        |   30 ++++--------------------------
>  4 files changed, 35 insertions(+), 27 deletions(-)
> 
> ===================================================================
> --- /dev/null
> +++ b/arch/x86_64/kernel/bugs.c
> @@ -0,0 +1,28 @@
> +/*
> + *  arch/x86_64/kernel/bugs.c
> + *
> + *  Copyright (C) 1994  Linus Torvalds
> + *  Copyright (C) 2000  SuSE
> + *
> + * This is included by init/main.c to check for architecture-dependent bugs.

drop comment.

Are you going to tackle asm-i386/bugs.h also?

Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
