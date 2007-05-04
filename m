Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbXEDOTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbXEDOTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbXEDOTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:19:09 -0400
Received: from ozlabs.org ([203.10.76.45]:34195 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbXEDOTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:19:08 -0400
Subject: Re: [RFC PATCH 1/3] Replace paravirt_probe with "platform type"
	boot header field
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <m1zm4ksn5o.fsf@ebiederm.dsl.xmission.com>
References: <1178283582.23670.67.camel@localhost.localdomain>
	 <m1zm4ksn5o.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Sat, 05 May 2007 00:18:49 +1000
Message-Id: <1178288329.23670.86.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 08:01 -0600, Eric W. Biederman wrote:
> We should place that initial branch right after startup_32,
> we don't need the startup_paravirt at all now.
> 
> ENTRY(startup_32)
> #ifdef CONFIG_LGUEST_GUEST
>         cmpl	$1, 0x23c(%esi)
> 	je      lguest_init
> #endif

Hi Eric!

	Makes sense to me, but I wasn't sure... do we need to check for old
bootloader versions and such?

Thanks,
Rusty.

