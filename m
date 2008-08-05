Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbYHECKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbYHECKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 22:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYHECKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 22:10:15 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:45722 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbYHECKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 22:10:14 -0400
Date: Tue, 5 Aug 2008 11:04:21 +0900
To: davem@davemloft.net
Cc: joerg.roedel@amd.com, akpm@linux-foundation.org, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, rth@twiddle.net, paulus@samba.org,
       benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp,
       muli@il.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] sparc64: use iommu_num_pages function in IOMMU
 code
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080804.142834.171476315.davem@davemloft.net>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
	<1217865890-3593-11-git-send-email-joerg.roedel@amd.com>
	<20080804.142834.171476315.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080805110416E.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Aug 2008 14:28:34 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Mon, 4 Aug 2008 18:04:50 +0200
> 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> So we rename, then convert everything back.
> 
> This seems like a lot of commit masterbation for what is
> clearly one single change.

The first patch adds a helper function, iommu_nr_pages(). Then the
following patches (or a single patch) convert all the IOMMUs to use
it.

If we really like 'iommu_num_pages' function name, then a single patch
can replace all iommu_nr_pages().
