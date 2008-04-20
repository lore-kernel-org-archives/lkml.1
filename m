Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbYDTHrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbYDTHrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 03:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYDTHrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 03:47:32 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:40061 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbYDTHrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 03:47:31 -0400
Message-ID: <480AF43D.1090405@linux.vnet.ibm.com>
Date: Sun, 20 Apr 2008 13:13:57 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Paul Menage <menage@google.com>, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       containers@lists.osdl.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][-mm] Memory controller hierarchy support (v1)
References: <20080419053551.10501.44302.sendpatchset@localhost.localdomain> <4809CDB7.3000105@openvz.org>
In-Reply-To: <4809CDB7.3000105@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> 
> Are you going to split this patch? As is it looks rather huge :)
> 

Sure

>> TODO's/Open Questions
>>
>> 1. We need to hold cgroup_mutex while walking through the children
>>    in reclaim. We need to figure out the best way to do so. Should
>>    cgroups provide a helper function/macro for it?
>> 2. Do not allow children to have a limit greater than their parents.
>> 3. Allow the user to select if hierarchial support is required
>> 4. Fine tune reclaim from children logic
>>
> 
> I though about it recently. Can we have a cgroup file, which will
> control whether to attach a res_counter to the parent? This will
> address the YEMEMOTO's question about the performance.
> 

It's one of the TODOS

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
