Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbYKNH6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbYKNH6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 02:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYKNH6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 02:58:12 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:49882 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYKNH6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 02:58:11 -0500
Message-ID: <491D2F67.1070302@linux.vnet.ibm.com>
Date: Fri, 14 Nov 2008 13:27:27 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080715)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jan Blunck <jblunck@suse.de>, containers@lists.osdl.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: reduce size of per-cpu-stat to be appropriate
 size.
References: <20081113164201.GV29067@bolzano.suse.de> <20081113191837.18ed2ade.akpm@linux-foundation.org> <491CF609.3050203@cn.fujitsu.com> <20081114132840.98d38f12.kamezawa.hiroyu@jp.fujitsu.com> <20081114144926.d91f36fd.kamezawa.hiroyu@jp.fujitsu.com> <491D2C21.5000600@linux.vnet.ibm.com> <20081114164812.a0d70ef5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081114164812.a0d70ef5.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 14 Nov 2008 13:13:29 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>> +static int mem_cgroup_size(void)
>> inline this function?
>>
> necessary ? 

Not really, but might be good for older compilers.

-- 
	Balbir
