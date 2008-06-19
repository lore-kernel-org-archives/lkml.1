Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbYFSAmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbYFSAmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbYFSAmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:42:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52645 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755645AbYFSAmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:42:06 -0400
Message-ID: <4859AAF8.9060909@cn.fujitsu.com>
Date: Thu, 19 Jun 2008 08:40:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cgroup: support checking of subsystem dependencies
References: <4858C0ED.2080905@cn.fujitsu.com> <20080619091714.320fdaa6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080619091714.320fdaa6.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 18 Jun 2008 16:01:49 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> This allows one subsystem to require that it only be mounted when some
>> other subsystems are also present in the proposed hierarchy.
>>
>> For example if subsystem foo depends on bar, the following will fail:
>>  # mount -t cgroup -ofoo xxx /dev/cgroup
>>
>> You should mount with both subsystems:
>>  # mount -t cgroup -ofoo,bar xxx /dev/cgroup
>>
> I'm just curious. May I ask "Is there such cgroup subsystem now ?"
> 

Currently no, but people who are developing or wants to develop new subsystems
may find this useful, for example Daisuke Nishimura-san's swap controller.

