Return-Path: <linux-kernel-owner+w=401wt.eu-S1761017AbYFGOiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017AbYFGOiZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 10:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYFGOiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 10:38:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:51844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135AbYFGOiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 10:38:17 -0400
Message-ID: <484A9D52.2020703@colorfullife.com>
Date: Sat, 07 Jun 2008 16:38:10 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Solofo.Ramangalahy@bull.net
CC: linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>, Nadia Derbey <Nadia.Derbey@bull.net>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC -mm 0/6] sysv ipc: scale msgmnb with the number of cpus
References: <20080605145712.116223941@bull.net>>
In-Reply-To: <20080605145712.116223941@bull.net>>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Solofo.Ramangalahy@bull.net wrote:
> The size in bytes of a SysV IPC message queue, msgmnb, is too small
> for large machines, but we don't want to bloat small machines
>
> Several methods are used already to modify (mainly increase) msgmnb:
> . distribution specific patch
> . system wide sysctl.conf
> . application specific tuning via /proc/sys/kernel/msgmnb
>
>   
Which distributions use a patch?

The whole configuration can be done from user space, thus I assumed that 
a sysctl.conf value (or in the worst case: a dbus/hal daemon that 
updates /proc/sys/kernel/msgnmb) could do the job.

--
    Manfred
