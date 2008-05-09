Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbYEINfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbYEINfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 09:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYEINfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 09:35:08 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:41430 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbYEINfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 09:35:06 -0400
Message-ID: <48245308.9010401@linux.vnet.ibm.com>
Date: Fri, 09 May 2008 19:05:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 3/4] Add rlimit controller accounting and control
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain> <20080503213814.3140.66080.sendpatchset@localhost.localdomain> <6599ad830805062029m37b507dcue737e1affddeb120@mail.gmail.com> <48230FBB.20105@linux.vnet.ibm.com> <6599ad830805081445w5991b47cld2861aab26ac6323@mail.gmail.com>
In-Reply-To: <6599ad830805081445w5991b47cld2861aab26ac6323@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Thu, May 8, 2008 at 7:35 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  I currently intend to use this controller for controlling memory related
>>  rlimits, like address space and mlock'ed memory. How about we use something like
>>  "memrlimit"?
> 
> Sounds reasonable.
> 
>>  Good suggestion, but it will be hard if not impossible to account the data
>>  correctly as it changes, if we do the accounting/summation at bind time. We'll
>>  need a really big lock to do it, something I want to avoid. Did you have
>>  something else in mind?
> 
> Yes, it'll be tricky but I think worthwhile. I believe it can be done
> without the charge/uncharge code needing to take a global lock, except
> for when we're actually binding/unbinding, with careful use of RCU.
> 

[snip]

This is an optimization that I am willing to consider later in the project. At
first I want to focus on functionality. I would like to optimize once I know
that the functionality has been well tested by a good base of users and make
sure that the optimization is real.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
