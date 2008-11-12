Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYKLPh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYKLPh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 10:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYKLPht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 10:37:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42896 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYKLPhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 10:37:48 -0500
Message-ID: <491AF801.3030302@redhat.com>
Date: Wed, 12 Nov 2008 10:36:33 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: ananth@in.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [PATCH 5/7] kprobes: Remove called_from argument
References: <4919F1A9.5070601@redhat.com> <20081112065238.GB3081@in.ibm.com>
In-Reply-To: <20081112065238.GB3081@in.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ananth,

Ananth N Mavinakayanahalli wrote:
> 
> You also need the following to get this to compile, don't you?

Oops, Indeed.
Thank you very much!
Where I've lost this parts...?

> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> 
> Index: linux-2.6.28-rc4/kernel/kprobes.c
> ===================================================================
> --- linux-2.6.28-rc4.orig/kernel/kprobes.c	2008-11-12 11:13:30.000000000 +0530
> +++ linux-2.6.28-rc4/kernel/kprobes.c	2008-11-12 12:18:44.000000000 +0530
> @@ -666,8 +666,6 @@
>  	 */
>  	probed_mod = __module_text_address((unsigned long) p->addr);
>  	if (probed_mod) {
> -		struct module *calling_mod;
> -		calling_mod = __module_text_address(called_from);
>  		/*
>  		 * We must hold a refcount of the probed module while updating
>  		 * its code to prohibit unexpected unloading.

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

