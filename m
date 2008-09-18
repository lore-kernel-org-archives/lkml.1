Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbYIRHBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbYIRHBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 03:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYIRHBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 03:01:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44246 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYIRHBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 03:01:10 -0400
Date: Thu, 18 Sep 2008 15:58:26 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Subject: Re: Populating multiple ptes at fault time
Cc: kosaki.motohiro@jp.fujitsu.com, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Hugh Dickens" <hugh@veritas.com>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>
In-Reply-To: <28c262360809171650g1395bbe2ya4e560851d37760d@mail.gmail.com>
References: <48D142B2.3040607@goop.org> <28c262360809171650g1395bbe2ya4e560851d37760d@mail.gmail.com>
Message-Id: <20080920035706.BAD6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, all
> 
> I have been thinking about this idea in native.
> I didn't consider it in minor page fault.
> As you know, it costs more cheap than major fault.
> However, the page fault is one of big bottleneck on demand-paging system.
> I think major fault might be a rather big overhead in many core system.
> 
> What do you think about this idea in native ?
> Do you really think that this idea don't help much in native ?
> 
> If I implement it in native, What kinds of benchmark do I need?
> Could you recommend any benchmark ?

I guess it is also useful for native.
Then, if you post patch & benchmark result, I'll review it with presusure.




