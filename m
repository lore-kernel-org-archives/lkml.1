Return-Path: <linux-kernel-owner+w=401wt.eu-S1758413AbXH2BgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbXH2BgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 21:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbXH2Bf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 21:35:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49417 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbXH2Bf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 21:35:56 -0400
Message-ID: <46D4CC81.4060400@zytor.com>
Date: Tue, 28 Aug 2007 18:31:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible
 fashion.
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>	<20070828230459.GA15937@infradead.org> <m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
>> Umm, no way we're ever going to remove a syscall like this.  
> 
> If someone besides me cares about more then rhetoric I will be happy
> to reconsider and several years is plenty of time to find that out.
> 
> I aborted the removal last time precisely because we had not done an
> adequate job of warning our users.  A printk when we run a program
> that uses the binary interface and an long enough interval the warning
> makes it to the Enterprise kernels before we remove the interface
> should be sufficient.
> 

glibc uses it, and it uses it in contexts where access to the filesystem 
isn't functional (e.g. in chroot.)

	-hpa
