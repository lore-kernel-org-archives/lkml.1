Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYFYHa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYFYHa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 03:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbYFYHaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 03:30:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52733 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbYFYHaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 03:30:14 -0400
Date: Wed, 25 Jun 2008 16:29:10 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Subject: Re: [RFC][PATCH] prevent incorrect oom under split_lru
Cc: kosaki.motohiro@jp.fujitsu.com, "Rik van Riel" <riel@redhat.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>, akpm@linux-foundation.org,
       "Takenori Nagano" <t-nagano@ah.jp.nec.com>
In-Reply-To: <28c262360806242358q348e18a4vb9c48b4b853b0384@mail.gmail.com>
References: <28c262360806242356n3f7e02abwfee1f6acf0fd2c61@mail.gmail.com> <28c262360806242358q348e18a4vb9c48b4b853b0384@mail.gmail.com>
Message-Id: <20080625161753.D848.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > But if such emergency happen in embedded system, application can't be
> > executed for some time.
> > I am not sure how long time it take.
> > But In some application, schedule period is very important than memory
> > reclaim latency.
> >
> > Now, In your patch, when such emergency happen, it continue to reclaim
> > page until it will scan entire page of lru list.
> > It
> 
> with my mistake, I omit following message. :(
> 
> So, we need cut-off mechanism to reduce application latency.
> So In my opinion, If we modify some code of Takenori's patch, we can
> apply his idea to prevent latency probelm.

Yup.
Agreed with latency is as important as throughput.

if anyone explain that patch have reduce some latency and 
no throughput degression by benchmark result,
I have no objection, Of cource.

Can you post any performance result?




