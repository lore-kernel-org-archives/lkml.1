Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbYI0G6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbYI0G6i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 02:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYI0G6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 02:58:30 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:55803 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYI0G6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 02:58:30 -0400
Message-ID: <48DDD98D.3050303@linux.vnet.ibm.com>
Date: Sat, 27 Sep 2008 12:28:21 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 5/12] memcg make page_cgroup->flags atomic
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com> <20080925151734.5b24d494.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080925151734.5b24d494.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> This patch makes page_cgroup->flags to be atomic_ops and define
> functions (and macros) to access it.
> 
> This patch itself makes memcg slow but this patch's final purpose is 
> to remove lock_page_cgroup() and allowing fast access to page_cgroup.
> (And total performance will increase after all patches applied.)
> 

Looks good to me

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
provided we push in the lockless ones too :)

-- 
	Balbir
