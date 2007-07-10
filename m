Return-Path: <linux-kernel-owner+w=401wt.eu-S1763653AbXGJJW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763653AbXGJJW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763725AbXGJJWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:22:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39829 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763692AbXGJJWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:22:35 -0400
Date: Tue, 10 Jul 2007 02:22:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Amit Arora <aarora@in.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: -mm merge plans for 2.6.23 -- sys_fallocate
Message-Id: <20070710022213.81e7b432.akpm@linux-foundation.org>
In-Reply-To: <20070710090737.GA16519@osiris.boeblingen.de.ibm.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070710090737.GA16519@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 11:07:37 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> > fallocate-implementation-on-i86-x86_64-and-powerpc.patch
> 
> Still broken: arch/x86_64/ia32/ia32entry.S wants compat_sys_fallocate instead
> of sys_fallocate. Also compat_sys_fallocate probably should be moved to
> fs/compat.c.
> 
> > fallocate-on-s390.patch
> 
> We reserved a different syscall number than the one that is used right now
> in the patch. Please drop this patch... Martin or I will wire up the syscall
> as soon as the x86 variant is merged. Everything else just causes trouble and
> confusion.

OK, I dropped all the fallocate patches.

That means that a few other syscalls (or at least, revoke) get renumbered.
