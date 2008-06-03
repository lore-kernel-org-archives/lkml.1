Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYFCW7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYFCW7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYFCW7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:59:38 -0400
Received: from sh.osrg.net ([192.16.179.4]:39500 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753AbYFCW7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:59:37 -0400
Date: Wed, 4 Jun 2008 07:58:40 +0900
To: dhowells@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH -mm] clean up duplicated alloc/free_thread_info
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <26320.1212484490@redhat.com>
References: <20080603140620S.fujita.tomonori@lab.ntt.co.jp>
	<26320.1212484490@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080604080140T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2008 10:14:50 +0100
David Howells <dhowells@redhat.com> wrote:

> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > - frv, m32r, mips, mn10300, and sh uses kmalloc/kfree instead of
> > __get_free_pages/free_pages. I let them alone but it could remove more
> > code if __get_free_pages/free_pages works for them.
> 
> On FRV, PAGE_SIZE is 16Kb, THREAD_SIZE is half that.

Thanks,

>From a quick look, seems that on m32r, mips, mn10300, and sh,
THREAD_SIZE is a multiple of PAGE_SIZE.
