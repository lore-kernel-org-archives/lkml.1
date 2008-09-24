Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbYIXG7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbYIXG7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 02:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYIXG7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 02:59:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52856 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYIXG7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 02:59:09 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Michael Rubin" <mrubin@google.com>
Subject: Re: [RFC] [PATCH -mm 0/2] memcg: per cgroup dirty_ratio
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Andrew Morton" <akpm@linux-foundation.org>, dradford@bluehost.com,
       m.innocenti@cineca.it, fernando@oss.ntt.co.jp,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
       agk@sourceware.org, matt@bluehost.com, menage@google.com,
       "Andrea Righi" <righi.andrea@gmail.com>, eric.rannaud@gmail.com,
       balbir@linux.vnet.ibm.com
In-Reply-To: <532480950809231321g7be0dd09pe6a32426b361e676@mail.gmail.com>
References: <20080924024437.DC21.KOSAKI.MOTOHIRO@jp.fujitsu.com> <532480950809231321g7be0dd09pe6a32426b361e676@mail.gmail.com>
Message-Id: <20080924143217.9B2E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 24 Sep 2008 15:59:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We don't have any motivation of its interface change.
> 
> We are seeing problems where we are generating a lot of dirty memory
> from asynchronous background writes while more important traffic is
> operating with DIRECT_IO. The DIRECT_IO traffic will incur high
> latency spikes as the pdflush hits the background threshold and tries
> to write a lot of dirty buffers at once.
> 
> What we want to do is lower the background threshold low enough so
> that we don't end up writing a lot of data at one time. As systems get
> more and more memory this is and will become difficult. 1% of system
> RAM could tie up a disk.

yup.
sorry, I choosed bad word at my last mail. it caused your confusion.
I only disagreed vm_dirty_KB.

I agreed with fine graind vm_dirty_ratio.

Thanks.


