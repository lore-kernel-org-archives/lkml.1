Return-Path: <linux-kernel-owner+w=401wt.eu-S966878AbXJTACM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966878AbXJTACM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 20:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765037AbXJTABz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 20:01:55 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40925 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208AbXJTABy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 20:01:54 -0400
Date: Fri, 19 Oct 2007 17:01:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Avuton Olrich" <avuton@gmail.com>, ebiederm@xmission.com
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: In function sysctl_check_lookup: undef ref to sysctl_head_next
Message-Id: <20071019170111.94219a4e.randy.dunlap@oracle.com>
In-Reply-To: <3aa654a40710182127u529efe5flc01955f01b83b042@mail.gmail.com>
References: <3aa654a40710182127u529efe5flc01955f01b83b042@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 21:27:16 -0700 Avuton Olrich wrote:

> Good Day,
> 
> My randconfig just caught an error on:
> kernel/built-in.o: In function `sysctl_check_lookup':
> sysctl_check.c:(.text+0x17db1): undefined reference to `sysctl_head_next'
> sysctl_check.c:(.text+0x17dc7): undefined reference to `sysctl_head_finish'
> 
> Git bisect was unsuccessful due to too many unrelated errors trying to
> track down the issue. I also couldn't track down the offending
> function. Any idea of the issue?
> 
> Against this config: http://avuton.googlepages.com/sysctl-head-next.config
> 
> git master: 4fa4d23fa20de67df919030c1216295664866ad7

Eric,

Please have a look at this one.

.config file link is above.

# CONFIG_SYSCTL_SYSCALL is not set
# CONFIG_PROC_SYSCTL is not set

Thanks,
---
~Randy
