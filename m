Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbYKSG5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbYKSG5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbYKSG5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:57:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbYKSG5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:57:06 -0500
Date: Tue, 18 Nov 2008 22:56:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Blackfin SMP like patchset
Message-Id: <20081118225621.540416ae.akpm@linux-foundation.org>
In-Reply-To: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
References: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 17:05:03 +0800 Bryan Wu <cooloney@kernel.org> wrote:

> 
> Hi folks,
> 
> We provide the SMP like functions for our Blackfin dual core processor
> BF561 for almost 1 year. And after a long time developing, debugging and
> internal review, we'd like to post them to LKML for other maintainer 
> review.
> 
> Please find our wiki page about this SMP like patches:
> http://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:smp-like

Would prefer that changelogs be self-contained, please.  Kernel
changelogs are for ever, and I doubt if that page will be there in 20
years time.

Particularly when that page must be read to learn fundamental things such as

  The SMP support in certain Blackfin processors is describe as `SMP
  Like' rather than just `SMP' due to the lack of hardware cache
  coherency.  A true SMP system would have support for cache coherency
  in hardware.

  On all `SMP Like' setups, cache coherency is maintained via
  software mechanisms

Interesting!


