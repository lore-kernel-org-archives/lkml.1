Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbYJNWF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbYJNWF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYJNWFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:05:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYJNWFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:05:49 -0400
Subject: Re: GPL question: using large contiguous memory in proprietary
	driver.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kaz Kylheku <kkylheku@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com>
References: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 00:05:42 +0200
Message-Id: <1224021942.16038.66.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 14:56 -0700, Kaz Kylheku wrote:
> Hi all,
> 
> I have the following question. Suppose that some proprietary driver
> (otherwise completely clean, based only on non-GPL symbols)
> requires a large buffer of physically contiguous memory.
> 
> A GPL-ed driver could get this memory by having some boot-time
> code compiled into the kernel which calls bootmem_alloc during
> kernel initialization. This function would stash the address of the
> memory into some global variable which is exported for the
> module to use.
> 
> How do you solve this problem in a proprietary driver? It seems
> like the above solution taints the kernel, because the kernel
> provides a symbol which exists only for the sake of supporting
> a proprietary driver.
> 
> Would it be okay to have a mechanism like this:
> Suppose that  on the kernel command line, you could
> request a boot-time memory allocation and give it a name.
> For instance, the parameter:
> 
>    boot_alloc=foo,8192K
> 
> would create an 8192 kilobyte allocation, and associate it
> with the string "foo".   A non-GPL function would be provided to
> find the address of this memory, using the string "foo"
> as the key. The proprietary driver would document the
> requirement that it needs a memory region of at least
> 8192K, under the name "foo".

Any GPL driver doing that deserves to be taken out and shot just as bad
as anyone else ;-)

That said, I don't think you'll find much sympathy here for non-GPL
kernel modules.

