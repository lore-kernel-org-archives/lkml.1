Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbYJZNQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbYJZNQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 09:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYJZNQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 09:16:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40908 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbYJZNQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 09:16:11 -0400
To: =?us-ascii?Q?=3D=3FISO-8859-1=3FQ=3FFr=3DE9d=3DE9ric=5FWeisbecker=3F?=
	 =?us-ascii?Q?=3D?= <fweisbec@gmail.com>
Cc: =?us-ascii?Q?=3D=3FISO-8859-1=3FQ=3FT=3DF6r=3DF6k=5FEdwin=3F=3D?= 
	<edwintorok@gmail.com>,
       mingo@elte.hu, srostedt@redhat.com, a.p.zijlstra@chello.nl,
       sandmann@daimi.au.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add support for userspace stacktraces in tracing/iter_ctrl
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
	<1223817124-27239-3-git-send-email-edwintorok@gmail.com>
	<c62985530810252105k3bce2339k5a49c09fa502ac67@mail.gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sun, 26 Oct 2008 09:15:42 -0400
In-Reply-To: <c62985530810252105k3bce2339k5a49c09fa502ac67@mail.gmail.com> (fweisbec@gmail.com's message of "Sun, 26 Oct 2008 05:05:48 +0100")
Message-ID: <y0mbpx71oqp.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com> writes:

> [...]
>> +/* Userspace stacktrace - based on kernel/trace/trace_sysprof.c */
>> +
>> +struct stack_frame {
>> +       const void __user       *next_fp;
>> +       unsigned long           return_address;
>> +};
> [...]

To what extent does this actually work, and on which architectures?
While the kernel appears willing to sacrifice some performance for
functionality by building with frame pointers at the drop of a tracing
hat, userspace is not like that.

- FChE
