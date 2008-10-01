Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbYJAGfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbYJAGfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 02:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbYJAGfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 02:35:36 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:58262 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYJAGff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 02:35:35 -0400
Message-ID: <48E31821.6070004@linux.vnet.ibm.com>
Date: Wed, 01 Oct 2008 11:56:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 9/12] memcg allocate all page_cgroup at boot
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com> <20080925153206.281243dc.kamezawa.hiroyu@jp.fujitsu.com> <48E2F6A9.9010607@linux.vnet.ibm.com> <20081001140748.637b9831.kamezawa.hiroyu@jp.fujitsu.com> <48E30B02.3030506@linux.vnet.ibm.com> <20081001144150.3faa92ea.kamezawa.hiroyu@jp.fujitsu.com> <20081001151249.b6d697a5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081001151249.b6d697a5.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 1 Oct 2008 14:41:50 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
>>> It will be easier to test/debug as well, we'll know if the problem is because of
>>> new page_cgroup being outside struct page rather then guessing if it was the
>>> atomic ops that caused the problem.
>>>
>> atomic_ops patch just rewrite exisiting behavior.
>>
> please forgive me to post v6 today, which passed 24h+ tests.
> v5 is a week old.
> Discussion about patch order is welcome. But please give me hint.

That sounds impressive. I'll test and review v6.

-- 
	Balbir
