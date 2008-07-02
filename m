Return-Path: <linux-kernel-owner+w=401wt.eu-S1762313AbYGBEs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313AbYGBEs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 00:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbYGBEsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 00:48:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752560AbYGBEsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 00:48:17 -0400
Date: Tue, 1 Jul 2008 21:46:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: alexisb@us.ibm.com, linux-kernel@vger.kernel.org, muli@il.ibm.com,
       mingo@elte.hu
Subject: Re: [PATCH -mm] fix per-device dma_mapping_ops support
Message-Id: <20080701214614.be6937be.akpm@linux-foundation.org>
In-Reply-To: <20080702132903E.fujita.tomonori@lab.ntt.co.jp>
References: <20080701194840.258b500f.akpm@linux-foundation.org>
	<20080702124328B.fujita.tomonori@lab.ntt.co.jp>
	<20080701210620.1e90e1fd.akpm@linux-foundation.org>
	<20080702132903E.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 13:29:19 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > OK..  Looks like this needs to be folded into
> > dma-mapping-x86-per-device-dma_mapping_ops-support prior to merging to
> > keep everything bisect-happy.
> 
> This doesn't need to be fold though it could.
> 
> This patch uses per-device-dma_mapping_ops support so this need to be
> applied after the per-device-dma_mapping_ops patchset.

OK, fine, let's keep them separate commits then.
