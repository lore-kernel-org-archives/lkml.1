Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYBRGYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYBRGYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 01:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYBRGYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 01:24:41 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:32952 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752443AbYBRGYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 01:24:41 -0500
Message-ID: <47B923C8.3090904@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2008 11:50:56 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
CC: lizf@cn.fujitsu.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] memcgroup: fix typo in VM_BUG_ON()
References: <47B9223C.9020106@linux.vnet.ibm.com> <20080218062209.DA59B1E3C58@siro.lan>
In-Reply-To: <20080218062209.DA59B1E3C58@siro.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YAMAMOTO Takashi wrote:
>> Li Zefan wrote:
>>> No need for VM_BUG_ON(pc), since 'pc' is the list entry. This should
>>> be VM_BUG_ON(page).
>>>
>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> pc is of type page_cgroup and we use list_for_each_entry_safe_reverse. Not sure
>> why we can't bug on pc.
> 
> pc is dereferenced before this VM_BUG_ON.
> 
> YAMAMOTO Takashi
> 

OK, so the VM_BUG_ON needs to move to an earlier location. Agreed.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
