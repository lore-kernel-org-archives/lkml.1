Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYIAG3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYIAG3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 02:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYIAG30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 02:29:26 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:35987 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYIAG3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 02:29:25 -0400
Message-ID: <48BB8B77.7060508@linux.vnet.ibm.com>
Date: Mon, 01 Sep 2008 11:58:07 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelianov <xemul@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] res_counter: fix off-by-one bug in setting limit
References: <48BB78E7.5080001@cn.fujitsu.com>
In-Reply-To: <48BB78E7.5080001@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> I found we can no longer set limit to 0 with 2.6.27-rcX:
>  # mount -t cgroup -omemory xxx /mnt
>  # mkdir /mnt/0
>  # echo 0 > /mnt/0/memory.limit_in_bytes
>  bash: echo: write error: Device or resource busy
> 
> It turned out 'limit' can't be set to 'usage', which is wrong IMO.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

OK, based on Kamezawa's feedback and looking at the patch

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
