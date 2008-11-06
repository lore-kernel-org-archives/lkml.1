Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYKFNr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYKFNr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 08:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbYKFNrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 08:47:18 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:52629 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbYKFNrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 08:47:18 -0500
Message-ID: <4912F53A.2070407@linux.vnet.ibm.com>
Date: Thu, 06 Nov 2008 19:16:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 7/6] memcg: add atribute (for change bahavior of
 rmdir)
References: <20081105171637.1b393333.kamezawa.hiroyu@jp.fujitsu.com> <49129493.9070103@linux.vnet.ibm.com> <20081106194153.220157ec.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081106194153.220157ec.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 06 Nov 2008 12:24:11 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> KAMEZAWA Hiroyuki wrote:
>>> Weekly (RFC) update for memcg.
>>>
>>> This set includes
>>>
>>> 1. change force_empty to do move account rather than forget all
>> I would like this to be selectable, please. We don't want to break behaviour and
>> not everyone would like to pay the cost of movement.
> 
> How about a patch like this ? I'd like to move this as [2/7], if possible.
> It obviously needs painful rework. If I found it difficult, schedule this as [7/7].
> 
> BTW, cost of movement itself is not far from cost for force_empty.
> 
> If you can't find why "forget" is bad, please consider one more day.

The attributes seem quite reasonable, I've taken a quick look, not done a full
review or test.

-- 
	Balbir
