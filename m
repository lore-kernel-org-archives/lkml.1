Return-Path: <linux-kernel-owner+w=401wt.eu-S1760442AbZAGTAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442AbZAGTAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbZAGTAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:00:38 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:36855 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZAGTAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:00:37 -0500
Date: Thu, 8 Jan 2009 00:26:27 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/4] Memory controller soft limit patches
Message-ID: <20090107185627.GL4145@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20090107184110.18062.41459.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107184110.18062.41459.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 12:11:10AM +0530, Balbir Singh wrote:
> 
> Here is v1 of the new soft limit implementation. Soft limits is a new feature
> for the memory resource controller, something similar has existed in the
> group scheduler in the form of shares. We'll compare shares and soft limits
> below. I've had soft limit implementations earlier, but I've discarded those
> approaches in favour of this one.
> 
> Soft limits are the most useful feature to have for environments where
> the administrator wants to overcommit the system, such that only on memory
> contention do the limits become active. The current soft limits implementation
> provides a soft_limit_in_bytes interface for the memory controller and not
> for memory+swap controller. The implementation maintains an RB-Tree of groups
> that exceed their soft limit and starts reclaiming from the group that
> exceeds this limit by the maximum amount.
> 
> This is an RFC implementation and is not meant for inclusion
> 
> TODOs
> 
> 1. The shares interface is not yet implemented, the current soft limit
>    implementation is not yet hierarchy aware. The end goal is to add
>    a shares interface on top of soft limits and to maintain shares in
>    a manner similar to the group scheduler

Just to clarify, when there is no contention, you want to share memory
proportionally?

thanks,
-- 
regards,
Dhaval
