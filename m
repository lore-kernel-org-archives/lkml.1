Return-Path: <linux-kernel-owner+w=401wt.eu-S1765506AbYAaKso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765506AbYAaKso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765995AbYAaKsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:48:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765803AbYAaKsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:48:31 -0500
Date: Thu, 31 Jan 2008 05:48:19 -0500
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-ID: <20080131054819.6be037f8@riellaptop.surriel.com>
In-Reply-To: <20080131100838.1F3B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080130175439.1AFD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<1201703382.5459.3.camel@localhost>
	<20080131100838.1F3B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 10:17:48 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> on my test environment, my patch solve incorrect OOM.
> because, too small reclaim cause OOM.

That makes sense.

The version you two are looking at can return
"percentages" way larger than 100 in get_scan_ratio.

A fixed version of get_scan_ratio, where the
percentages always add up to 100%, makes the
system go OOM before it seriously starts
swapping.

I will integrate your fixes with my code when I
get back from holidays.  Then things should work :)

Thank you for your analysis of the problem.
