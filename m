Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYIRHVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYIRHVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 03:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYIRHVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 03:21:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35045 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYIRHVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 03:21:13 -0400
Date: Thu, 18 Sep 2008 16:26:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Hugh Dickens" <hugh@veritas.com>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>
Subject: Re: Populating multiple ptes at fault time
Message-Id: <20080918162644.1d4beab7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262360809171650g1395bbe2ya4e560851d37760d@mail.gmail.com>
References: <48D142B2.3040607@goop.org>
	<28c262360809171650g1395bbe2ya4e560851d37760d@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 08:50:05 +0900
"MinChan Kim" <minchan.kim@gmail.com> wrote:

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
Hmm, is enlarging page-size-for-anonymous-page more difficult ?
(maybe, yes.)

> If I implement it in native, What kinds of benchmark do I need?
> Could you recommend any benchmark ?
> 

Testing some kind of scripts (shell/perl etc..) is candidates.

I use unixbench's exec/shell test to see charge/uncharge overhead of memory
resource controller, which happens at major page fault.

Thanks,
-Kame

