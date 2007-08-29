Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbXH2B4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbXH2B4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 21:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbXH2B4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 21:56:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41390 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbXH2B4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 21:56:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
	<20070828230459.GA15937@infradead.org>
	<m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com>
	<46D4CC81.4060400@zytor.com>
Date: Tue, 28 Aug 2007 19:56:28 -0600
In-Reply-To: <46D4CC81.4060400@zytor.com> (H. Peter Anvin's message of "Tue,
	28 Aug 2007 18:31:45 -0700")
Message-ID: <m1d4x7aysz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> Christoph Hellwig <hch@infradead.org> writes:
>>
>>> Umm, no way we're ever going to remove a syscall like this.
>>
>> If someone besides me cares about more then rhetoric I will be happy
>> to reconsider and several years is plenty of time to find that out.
>>
>> I aborted the removal last time precisely because we had not done an
>> adequate job of warning our users.  A printk when we run a program
>> that uses the binary interface and an long enough interval the warning
>> makes it to the Enterprise kernels before we remove the interface
>> should be sufficient.
>>
>
> glibc uses it, and it uses it in contexts where access to the filesystem isn't
> functional (e.g. in chroot.)

Yes.  But (a) It doesn't affect correctness what answer it gets back.
          (b) It should be using uname.

Or are you thinking about something besides the pthreads usage?

Eric
