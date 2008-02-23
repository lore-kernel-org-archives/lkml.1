Return-Path: <linux-kernel-owner+w=401wt.eu-S1765043AbYBWKoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765043AbYBWKoL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 05:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYBWKn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 05:43:56 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:15553 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYBWKn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 05:43:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=TYVtsxW6k6nuDTihZmBAwU5zmU6Z4EJ+cFfRP4NVPMaGFA6wl/alG6TiCfoXxDPeX2gh7s+SsM8t0KNreAD46WQaDwuKYAMDvEeqzQPhBjV9mM7YFB3oDQxHIkYrDwG+P4Zgr8BR0kH2fgDa/9SrHyJnxky3DYcKHofx8F5R8YQ=
Date: Sat, 23 Feb 2008 18:39:01 +0800 (CST)
Message-Id: <20080223.183901.201654325.xiyou.wangcong@gmail.com>
To: mingo@elte.hu
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH 08/16] x86: use get_personality()
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080223101954.GA28929@elte.hu>
References: <12037545424136-git-send-email-xiyou.wangcong@gmail.com>
	<20080223100849.GC23833@elte.hu>
	<20080223101954.GA28929@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 08/16] x86: use get_personality()
Date: Sat, 23 Feb 2008 11:19:54 +0100
Message-ID: <20080223101954.GA28929@elte.hu>

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * WANG Cong <xiyou.wangcong@gmail.com> wrote:
> > 
> > > Use get_personality() macro instead of explicit reference for x86 
> > > code.
> > 
> > thanks, applied.
> 
> randconfig testing found the following build failures:
> 
>   arch/x86/kernel/process_64.c: In function 'do_arch_prctl':
>   arch/x86/kernel/process_64.c:836: error: called object 'get_current()->personality' is not a function
>   arch/x86/kernel/process_64.c:862: error: called object 'get_current()->personality' is not a function
> 
> so i dropped the patch again. Config attached.
> 
> 	Ingo

Sorry that I didn't mention that this patch should be applied
_after_ [patch 01/16], since in [patch 01/16] I made the macro
get_personality like a function.

Sorry for this. Just wait after [patch 01/16] is applied.

Thanks.
