Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbYDCEcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbYDCEcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 00:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYDCEcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 00:32:41 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:48817 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYDCEcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 00:32:41 -0400
Message-ID: <47F45DD9.4030004@linux.vnet.ibm.com>
Date: Thu, 03 Apr 2008 10:02:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][-mm] Add an owner to the mm_struct (v4)
References: <20080401124312.23664.64616.sendpatchset@localhost.localdomain> <47F3D62E.4070808@linux.vnet.ibm.com> <6599ad830804021253y6bf3b37y9bf1167b63c32e70@mail.gmail.com> <47F4577E.5060905@linux.vnet.ibm.com> <6599ad830804022110h2090f3efg7c6173df8185679e@mail.gmail.com>
In-Reply-To: <6599ad830804022110h2090f3efg7c6173df8185679e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Wed, Apr 2, 2008 at 9:05 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  I checked to see that cgroup_exit is called after mm_update_new_owner(). We call
>>  mm_update_new_owner() from exit_mm(). I did not check for current->cgroups !=
>>  new_owner->cgroups, since I did not want to limit the callbacks.
> 
> No cgroup subsystem should be concerned about mm ownership changes
> between tasks in the same cgroup. So I think that's a valid and useful
> optimization.
> 

Hmm. probably.. I'll do that check. Let me post v5 with these changes

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
