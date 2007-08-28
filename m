Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbXH1VJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbXH1VJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 17:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbXH1VJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 17:09:11 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48756 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbXH1VJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 17:09:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, samuel@sortiz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sysctl: Properly register the irda binary sysctl numbers.
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<23568.1187876026@turing-police.cc.vt.edu>
	<20070823141652.d488a6e0.akpm@linux-foundation.org>
	<m1wsvlmvu6.fsf_-_@ebiederm.dsl.xmission.com>
	<6634.1188030574@turing-police.cc.vt.edu>
	<m16433n55e.fsf@ebiederm.dsl.xmission.com>
	<2371.1188050875@turing-police.cc.vt.edu>
	<m1wsvjlckm.fsf@ebiederm.dsl.xmission.com>
	<5846.1188326457@turing-police.cc.vt.edu>
Date: Tue, 28 Aug 2007 15:06:28 -0600
In-Reply-To: <5846.1188326457@turing-police.cc.vt.edu> (Valdis Kletnieks's
	message of "Tue, 28 Aug 2007 14:40:57 -0400")
Message-ID: <m1zm0bbc8b.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu writes:

> On Sat, 25 Aug 2007 11:59:53 MDT, Eric W. Biederman said:
>
>> It looks like you don't have CONFIG_SYSCTL_SYSCALL defined, and it
>> appears utsname_syscall and ipcdata_syscall both become NULL pointers
>> if they aren't needed.  So the complaint is a false positive.
>
> Yep. Nothing I actually use needs SYSCTL_SYSCALL, so I turned it off to
> see what breaks...

Other then glibc (which uses it to see if we are on a SMP system, and
has a fallback to /proc/sys) I only found 5 other applications
binaries when I was looking hard.

Eric

