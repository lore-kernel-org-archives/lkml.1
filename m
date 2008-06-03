Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbYFCJPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbYFCJPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 05:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYFCJPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 05:15:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbYFCJPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 05:15:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080603140620S.fujita.tomonori@lab.ntt.co.jp>
References: <20080603140620S.fujita.tomonori@lab.ntt.co.jp>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH -mm] clean up duplicated alloc/free_thread_info
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 03 Jun 2008 10:14:50 +0100
Message-ID: <26320.1212484490@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> - frv, m32r, mips, mn10300, and sh uses kmalloc/kfree instead of
> __get_free_pages/free_pages. I let them alone but it could remove more
> code if __get_free_pages/free_pages works for them.

On FRV, PAGE_SIZE is 16Kb, THREAD_SIZE is half that.

David
