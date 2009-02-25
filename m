Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbZBYIDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbZBYIDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 03:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758096AbZBYIDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 03:03:18 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:55879 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZBYIDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 03:03:17 -0500
Date: Wed, 25 Feb 2009 13:33:07 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] cgroup allow subsys to set default mode of its own
	file
Message-ID: <20090225080307.GD11421@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090225163555.d2a0b24c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090225163555.d2a0b24c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-02-25 16:35:55]:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> cgroup's subsys has "readonly" files, but default permission is always
> rw-r--r--. This allows to create r--r--r-- file to subsys.
> (The user can do chmod on this read-only file. But this behavior is not
>  different from current pseudo file systems as /proc.)
> 
> Reason:
>  When I wrote tools for maintain cgroup, I can't find which file is
>  writable intarfece or not via cgroup file systems. (finally, I did
>  dirty approach.)
>  IMHO, showing "this file is read-only" in explicit way is useful
>  for user-land (tools). In other story, a file whose name sounds read-only
>  may have "trigger" operation and support reseting. In this case,
>  "writable" is informative.

Perfect, Thanks, Looks good to me

-- 
	Balbir
