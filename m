Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYFFEP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYFFEP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 00:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbYFFEPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 00:15:51 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:38603 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbYFFEPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 00:15:51 -0400
Message-ID: <4848B983.4030502@linux.vnet.ibm.com>
Date: Fri, 06 Jun 2008 09:43:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, nagar@watson.ibm.com, balbir@in.ibm.com,
       sekharan@us.ibm.com, kosaki.motohiro@jp.fujitsu.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 2/3 v2] per-task-delay-accounting: update taskstats for
 memory reclaim delay
References: <20080605162759.a6adf291.kobayashi.kk@ncos.nec.co.jp> <20080605163220.8397bed6.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20080605163220.8397bed6.kobayashi.kk@ncos.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keika Kobayashi wrote:
> Add members for memory reclaim delay to taskstats,
> and accumulate them in __delayacct_add_tsk() .
> 
> Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>

Two suggested changes

1. Please add all fields at the end (otherwise we risk breaking compatibility)
2. please also update Documentation/accounting/taskstats-struct.txt

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
