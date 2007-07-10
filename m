Return-Path: <linux-kernel-owner+w=401wt.eu-S1764071AbXGJJHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764071AbXGJJHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761063AbXGJJHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:07:40 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:38246 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762119AbXGJJHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:07:39 -0400
Date: Tue, 10 Jul 2007 11:07:37 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Amit Arora <aarora@in.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: -mm merge plans for 2.6.23 -- sys_fallocate
Message-ID: <20070710090737.GA16519@osiris.boeblingen.de.ibm.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> fallocate-implementation-on-i86-x86_64-and-powerpc.patch

Still broken: arch/x86_64/ia32/ia32entry.S wants compat_sys_fallocate instead
of sys_fallocate. Also compat_sys_fallocate probably should be moved to
fs/compat.c.

> fallocate-on-s390.patch

We reserved a different syscall number than the one that is used right now
in the patch. Please drop this patch... Martin or I will wire up the syscall
as soon as the x86 variant is merged. Everything else just causes trouble and
confusion.
