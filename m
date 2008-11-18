Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbYKRFVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbYKRFVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 00:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbYKRFVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 00:21:36 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53634 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715AbYKRFVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 00:21:36 -0500
Subject: Re: pci_map_sg() does not coalesce adjacent physical memory? x86
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Leon Woestenberg <leon.woestenberg@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Tejun Heo <tj@kernel.org>
In-Reply-To: <20081117191532.c1c849f5.akpm@linux-foundation.org>
References: <c384c5ea0811171354u5d6f5be6v857f92b1e75769c7@mail.gmail.com>
	 <20081117191532.c1c849f5.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 14:21:29 +0900
Message-Id: <1226985689.3403.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-17 at 19:15 -0800, Andrew Morton wrote:
> (cc's added)
> 
> On Mon, 17 Nov 2008 22:54:33 +0100 "Leon Woestenberg" <leon.woestenberg@gmail.com> wrote:
> 
> > Hello,
> > 
> > pci_map_sg() does not coalesce the scattergather list for me on x86.
> 
> In which kernel version(s)?

Also which driver?  Some manually disable physical merging, so they will
never coalesce adjacent pages.

You need the flag QUEUE_FLAG_CLUSTER set for physical merging to take
place.

James


