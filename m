Return-Path: <linux-kernel-owner+w=401wt.eu-S1757694AbYAPBuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbYAPBuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbYAPBt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:49:59 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59407 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484AbYAPBt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:49:58 -0500
Date: Wed, 16 Jan 2008 10:48:55 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: =?ISO-2022-JP?B?IkRhbmllbCBTcBskQmlPGyhCZyI=?= 
	<daniel.spang@gmail.com>
Subject: Re: [RFC][PATCH 4/5] memory_pressure_notify() caller
Cc: kosaki.motohiro@jp.fujitsu.com, "Rik van Riel" <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "Marcelo Tosatti" <marcelo@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <cfd9edbf0801151539g72ca9777h7ac43a31aadc730e@mail.gmail.com>
References: <20080115175925.215471e1@bree.surriel.com> <cfd9edbf0801151539g72ca9777h7ac43a31aadc730e@mail.gmail.com>
Message-Id: <20080116104536.11AE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel

> > > The notification fires after only ~100 MB allocated, i.e., when page
> > > reclaim is beginning to nag from page cache. Isn't this a bit early?
> > > Repeating the test with swap enabled results in a notification after
> > > ~600 MB allocated, which is more reasonable and just before the system
> > > starts to swap.
> >
> > Your issue may have more to do with the fact that the
> > highmem zone is 128MB in size and some balancing issues
> > between __alloc_pages and try_to_free_pages.
> 
> I don't think so. I ran the test again without highmem and noticed the
> same behaviour:

Thank you for good point out!
Could you please post your test program and reproduced method?

unfortunately,
my simple test is so good works in swapless system ;-)

thanks.



