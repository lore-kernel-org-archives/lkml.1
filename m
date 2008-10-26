Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbYJZN3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbYJZN3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 09:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYJZN3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 09:29:34 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:6992 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYJZN3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 09:29:33 -0400
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 1/4] Add support for userspace stacktraces in
 tracing/iter_ctrl
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: fweisbec@gmail.com,
       =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>, mingo@elte.hu,
       srostedt@redhat.com, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org
In-Reply-To: <y0mbpx71oqp.fsf@ton.toronto.redhat.com>
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
	 <1223817124-27239-3-git-send-email-edwintorok@gmail.com>
	 <c62985530810252105k3bce2339k5a49c09fa502ac67@mail.gmail.com>
	 <y0mbpx71oqp.fsf@ton.toronto.redhat.com>
Content-Type: text/plain
Date: Sun, 26 Oct 2008 14:29:42 +0100
Message-Id: <1225027782.32713.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-26 at 09:15 -0400, Frank Ch. Eigler wrote:
> "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com> writes:
> 
> > [...]
> >> +/* Userspace stacktrace - based on kernel/trace/trace_sysprof.c */
> >> +
> >> +struct stack_frame {
> >> +       const void __user       *next_fp;
> >> +       unsigned long           return_address;
> >> +};
> > [...]
> 
> To what extent does this actually work, and on which architectures?
> While the kernel appears willing to sacrifice some performance for
> functionality by building with frame pointers at the drop of a tracing
> hat, userspace is not like that.

Aww, common, Gentoo is brilliant for that :-)

CFLAGS+=-fframe-pointer

emerge -uDNe world

Then again, you'd better not have all that desktop bloat installed,
otherwise that will take ages.. KDE/OOo compile times anyone?

/me runs

