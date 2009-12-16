Return-Path: <linux-kernel-owner+w=401wt.eu-S934576AbZLPCYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934576AbZLPCYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934570AbZLPCY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:24:26 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48168 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934568AbZLPCYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:24:24 -0500
Date: Wed, 16 Dec 2009 11:24:20 +0900 (JST)
Message-Id: <20091216.112420.71092752.d.hatayama@jp.fujitsu.com>
To: xiyou.wangcong@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       tony.luck@intel.com, mhiramat@redhat.com
Subject: Re: [RFC, PATCH 2/4] elf_core_dump(): Remove DUMP_WRITE macro
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
In-Reply-To: <2375c9f90912150029w6edafb17s6fb0bcf41798263a@mail.gmail.com>
References: <20091215.114125.71090684.d.hatayama@jp.fujitsu.com>
	<2375c9f90912150029w6edafb17s6fb0bcf41798263a@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, Dec 15, 2009 at 10:41 AM, Daisuke HATAYAMA
> <d.hatayama@jp.fujitsu.com> wrote:
> > In DUMP_WRITE macro, some local variables and goto statement are used
> > implicitly, which makes it confusing to understand how the dumping
> > process behaves. So, clean up it by unfolding the macro body directly
> > to the point where the original macro is used plus a bit of style
> > change.
> >
> > Now that the previous patch replaced ELF_CORE_EXTRA_* macros in
> > fs/binfmt_elf.c, there is no users for DUMP_WRITE macro in
> > fs/binfmt_elf.c. Thus remove the definition of DUMP_WRITE macro.
> >
> > Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
> 
> 
> I assume you at least did a build test?

Oh..sorry. I have forgotten writting about test.

For IA64, i386 and UML-i386, I tested on the real machine.
For s390, arm and xtensa, I only did a build test.

> I like this patch:

Thanks.

