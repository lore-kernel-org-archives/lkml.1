Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYDHCc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYDHCc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 22:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYDHCcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 22:32:46 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:41041 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYDHCcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 22:32:46 -0400
Message-ID: <47FAD8F9.7070308@linux.vnet.ibm.com>
Date: Tue, 08 Apr 2008 08:01:21 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: andi@firstfloor.org, Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pavel Emelianov <xemul@openvz.org>,
       hugh@veritas.com
Subject: Re: [-mm] Disable the memory controller by default (v2)
References: <20080407130215.26565.81715.sendpatchset@localhost.localdomain> <20080408100902.fcd9d911.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080408100902.fcd9d911.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 07 Apr 2008 18:32:15 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>>
>> Changelog v1
>>
>> 1. Split cgroup_disable into cgroup_disable and cgroup_enable
>> 2. Remove cgroup_toggle
>>
>> Due to the overhead of the memory controller. The
>> memory controller is now disabled by default. This patch adds cgroup_enable.
>>
>> If everyone agrees on this approach and likes it, should we push this
>> into 2.6.25?
>>
>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>> ---
> BTW, how the user can know which controllers are on/off at default ?
> All controllers are off ?
> 

/proc/cgroups has an enabled field (fourth one). That should show what is
enabled/disabled. I've also documented it in
Documentation/kernel-parameters.txt. I intend to enable the memory controller
again, once we bring down the overhead.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
