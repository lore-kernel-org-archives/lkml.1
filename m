Return-Path: <linux-kernel-owner+w=401wt.eu-S1761403AbYDCG3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403AbYDCG3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 02:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbYDCG3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 02:29:25 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:51864 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbYDCG3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 02:29:24 -0400
Message-ID: <47F47924.5050905@linux.vnet.ibm.com>
Date: Thu, 03 Apr 2008 11:58:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v5)
References: <20080403055901.31796.41411.sendpatchset@localhost.localdomain> <47F476FE.6040800@cn.fujitsu.com>
In-Reply-To: <47F476FE.6040800@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> #ifdef CONFIG_MM_OWNER
> 	.owner		= &init_task,
> #endif
> 
> Otherwise building broken with CONFIG_MM_OWNER disabled.

Good catch. Let me fix it and send v6

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
