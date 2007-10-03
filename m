Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbXJCVNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbXJCVNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 17:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbXJCVNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 17:13:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52872 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752747AbXJCVNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 17:13:42 -0400
Date: Wed, 3 Oct 2007 14:12:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: tomof@acm.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH -mm] intel-iommu sg chaining support
Message-Id: <20071003141203.fae1edf5.akpm@linux-foundation.org>
In-Reply-To: <20071001161256.GA28998@askeshav-devel.jf.intel.com>
References: <20070929125638W.tomof@acm.org>
	<20071001161256.GA28998@askeshav-devel.jf.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007 09:12:56 -0700
"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:

> On Sat, Sep 29, 2007 at 05:16:38AM -0700, FUJITA Tomonori wrote:
> > 
> >    x86_64 defines ARCH_HAS_SG_CHAIN. So if IOMMU implementations don't
> >    support sg chaining, we will get data corruption.
> >    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Acked-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> 

Am I correct in believing that this patch is needed only when the
chaining patches which are presently in git-block are combined with the
intel-iommu work which is presently in -mm?
