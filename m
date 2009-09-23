Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZIWGva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZIWGva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbZIWGva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:51:30 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:59516 "EHLO lvk.cs.msu.su"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbZIWGv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:51:29 -0400
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Inter-process send()/recv() using zero-copy ?
Date: Wed, 23 Sep 2009 10:51:31 +0400
User-Agent: KMail/1.9.9
References: <4AB9B9B7.1020309@exalead.com> <20090923084314.78283f24@infradead.org>
In-Reply-To: <20090923084314.78283f24@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909231051.31818@zigzag.lvk.cs.msu.su>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the problem you have is that
> 1) memory copies are cheap
>    (say, 3000 cycles/page or less)

What about L1 cache pollution? Doesn't it change situation?

> 2) page table operations (mmap etc) are very expensive.
>
> these two combined tend to not make it a win to substitute simple
> copies with complex pagetable tricks.


