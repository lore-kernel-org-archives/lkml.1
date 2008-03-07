Return-Path: <linux-kernel-owner+w=401wt.eu-S1762679AbYCGJFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762679AbYCGJFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbYCGJFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:05:38 -0500
Received: from smtp-out.google.com ([216.239.45.13]:61899 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbYCGJFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:05:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=wTBC9ctLXcoXeRSlo6tHtK5Ey3f+ipha7li86Gh03rBfKizDUVU8lwiePWzJCmZRr
	SgmzXfpsLmNfhi5EyG01g==
Date: Fri, 7 Mar 2008 01:04:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Add cgroup support for enabling controllers at boot time
 (v2)
In-Reply-To: <20080307085735.25567.314.sendpatchset@localhost.localdomain>
Message-ID: <alpine.DEB.1.00.0803070102020.4693@chino.kir.corp.google.com>
References: <20080307085735.25567.314.sendpatchset@localhost.localdomain>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Balbir Singh wrote:

> diff -puN Documentation/kernel-parameters.txt~cgroup_disable Documentation/kernel-parameters.txt
> --- linux-2.6.25-rc4/Documentation/kernel-parameters.txt~cgroup_disable	2008-03-07 14:26:16.000000000 +0530
> +++ linux-2.6.25-rc4-balbir/Documentation/kernel-parameters.txt	2008-03-07 14:26:16.000000000 +0530
> @@ -383,6 +383,10 @@ and is between 256 and 4096 characters. 
>  	ccw_timeout_log [S390]
>  			See Documentation/s390/CommonIO for details.
>  
> +	cgroup_disable= [KNL] Disable a particular controller
> +			Format: {name of the controller(s) to disable}
> +				{Currently supported controllers - "memory"}
> +
>  	checkreqprot	[SELINUX] Set initial checkreqprot flag value.
>  			Format: { "0" | "1" }
>  			See security/selinux/Kconfig help text.

It would probably be helpful to mention in the documentation that the 
names of the subsystems must now be delimited by commas.

 [ I also find it very helpful to add randy.dunlap@oracle.com to the cc
   list for any patch touching Documentation ]
