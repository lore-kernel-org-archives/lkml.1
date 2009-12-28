Return-Path: <linux-kernel-owner+w=401wt.eu-S1751507AbZL1Lnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbZL1Lnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZL1Lnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:43:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbZL1Lnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:43:51 -0500
Subject: Re: [RFC PATCH] asynchronous page fault.
From: Peter Zijlstra <peterz@infradead.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
In-Reply-To: <20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
	 <1261915391.15854.31.camel@laptop>
	 <20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 12:43:05 +0100
Message-ID: <1262000585.7135.84.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-28 at 09:36 +0900, KAMEZAWA Hiroyuki wrote:
> > the hard way
> > is to also incorporate the drop-mmap_sem on blocking patches from a
> > while ago.
> > 
> "drop-mmap_sem if block" is no help for this false-sharing problem.

No but it does help with the problem of RCU-read-lock not being able to
sleep.

