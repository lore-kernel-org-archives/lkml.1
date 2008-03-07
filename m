Return-Path: <linux-kernel-owner+w=401wt.eu-S1764639AbYCGNbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764639AbYCGNbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 08:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760327AbYCGNaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 08:30:55 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:51024 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757514AbYCGNay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 08:30:54 -0500
Message-ID: <47D1431C.6060107@linux.vnet.ibm.com>
Date: Fri, 07 Mar 2008 18:59:00 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Add cgroup support for enabling controllers at boot time
 (v2)
References: <20080307085735.25567.314.sendpatchset@localhost.localdomain> <6599ad830803070125o1ebfd7d1r728cdadf726ecbe2@mail.gmail.com> <6599ad830803070426l22d78446t588691dedeeb490b@mail.gmail.com> <47D13BF1.1060009@linux.vnet.ibm.com> <6599ad830803070509v1ec83aeet9f63bfd61a00ef19@mail.gmail.com>
In-Reply-To: <6599ad830803070509v1ec83aeet9f63bfd61a00ef19@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Mar 7, 2008 at 4:58 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  > Or rather, it's the other way around - cgroup_disable=cpuset will
>>  > instead disable the "cpu" subsystem if "cpu" comes before "cpuset" in
>>  > the subsystem list.
>>  >
>>
>>  Would it? I must be missing something, since we do a strncmp with ss->name.
>>  I would expect that to match whole strings.
>>
> 
> No, strncmp only checks the first n characters - so in that case,
> you'd be checking for !strncmp("cpuset", "cpu", 3), which will return
> true

Aaah.. I see the problem now.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
