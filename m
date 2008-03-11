Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbYCKKPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbYCKKPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbYCKKPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:15:19 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:59407 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbYCKKPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:15:18 -0400
Message-ID: <47D65BAA.60908@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2008 15:45:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 2/3] memcg: put a restriction on writing memory.force_empty
References: <47D65A36.4020008@cn.fujitsu.com>
In-Reply-To: <47D65A36.4020008@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> We can write whatever to memory.force_empty:
> 
>         echo 999 > memory.force_empty
>         echo wow > memory.force_empty
> 
> This is odd, so let's make '1' to be the only valid value.

I suspect as long as there is no unreasonable side-effect, writing 999 or wow
should be OK.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
