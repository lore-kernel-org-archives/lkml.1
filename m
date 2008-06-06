Return-Path: <linux-kernel-owner+w=401wt.eu-S1763786AbYFFDVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763786AbYFFDVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 23:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYFFDV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 23:21:29 -0400
Received: from homer.mvista.com ([63.81.120.158]:6817 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYFFDV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 23:21:29 -0400
Date: Thu, 5 Jun 2008 20:21:32 -0700
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: balbir@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, balbir@in.ibm.com, sekharan@us.ibm.com,
       kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 0/3 v2] per-task-delay-accounting: add memory reclaim
 delay
Message-Id: <20080605202132.d84b7083.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <48489E71.2060708@linux.vnet.ibm.com>
References: <20080605162759.a6adf291.kobayashi.kk@ncos.nec.co.jp>
	<48489E71.2060708@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 07:48:25 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> >     $ ./delayget -d -p <pid>
> >     CPU             count     real total  virtual total    delay total
> >                      2640     2456153500     2478353004       28366219
> >     IO              count    delay total
> >                      2628    19894214188
> >     SWAP            count    delay total
> >                         0              0
> >     RECLAIM         count    delay total
> >                      6600    10682486085
> > 
> 
> Looks interesting, this data is for the whole system or memcgroup? If it is for
> memcgroup, we should be using cgroupstats.

Thanks for your comment.
This accounting, which is named "RECLAIM", is global and memcgroup reclaim delay
and this data is value per task.

Unfortunately, I'm not sure what the whole system means.
Could you tell me your point?
