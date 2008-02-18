Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYBRGST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYBRGST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 01:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYBRGSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 01:18:07 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:33902 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751490AbYBRGSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 01:18:06 -0500
Message-ID: <47B9223C.9020106@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2008 11:44:20 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] memcgroup: fix typo in VM_BUG_ON()
References: <47B91EC2.3020805@cn.fujitsu.com>
In-Reply-To: <47B91EC2.3020805@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> No need for VM_BUG_ON(pc), since 'pc' is the list entry. This should
> be VM_BUG_ON(page).
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

pc is of type page_cgroup and we use list_for_each_entry_safe_reverse. Not sure
why we can't bug on pc.



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
