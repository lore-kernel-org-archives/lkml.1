Return-Path: <linux-kernel-owner+w=401wt.eu-S1752942AbZCLI1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbZCLI1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 04:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbZCLI04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 04:26:56 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:59694 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZCLI0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 04:26:55 -0400
Date: Thu, 12 Mar 2009 13:56:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/5] memcg softlimit (Another one) v4
Message-ID: <20090312082646.GA5828@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com> <20090312034647.GA23583@balbir.in.ibm.com> <20090312133949.130b20ed.kamezawa.hiroyu@jp.fujitsu.com> <20090312050423.GI23583@balbir.in.ibm.com> <20090312143212.50818cd5.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090312143212.50818cd5.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-12 14:32:12]:

> On Thu, 12 Mar 2009 10:34:23 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > Not yet.. you just posted it. I am testing my v5, which I'll post
> > soon. I am seeing very good results with v5. I'll test yours later
> > today.
> > 
> 
> If "hooks" to usual path doesn't exist and there are no global locks,
> I don't have much concern with your version.

Good to know. I think it is always good to have competing patches and
then collaborating and getting the best in.

> But 'sorting' seems to be overkill to me.
> 

Sorting is very useful, specially if you have many cgroups. Without
sorting, how do we select what group to select first.

> I'm sorry if my responce to your patch is delayed. I may not be in office.
>

No problem 

-- 
	Balbir
