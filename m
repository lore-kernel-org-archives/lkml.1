Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934009Ab0BQDqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 22:46:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45566 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933973Ab0BQDqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 22:46:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 17 Feb 2010 12:43:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Leonidas ." <leonidas137@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Notification when a task is created/exits
Message-Id: <20100217124312.e6d47c21.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <f22d86811002161916s292436b7hf564269a37dbe9af@mail.gmail.com>
References: <f22d86811002152148t4f307184kb71757f4621f82db@mail.gmail.com>
	<20100217115313.30de11fb.kamezawa.hiroyu@jp.fujitsu.com>
	<f22d86811002161916s292436b7hf564269a37dbe9af@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010 08:46:51 +0530
"Leonidas ." <leonidas137@gmail.com> wrote:
\
> >  2. implement cgroup subsystem
> >    AFAIK, in the latest kernel, cgroup subsystem can be implemented as module.
> >    cgroup has fork/exit handler.
> >    And you can implement some useful controls for tasks you watch via
> >    cgroup's control interface.
> >
> 
> This sounds close to what I have in mind, but unfortunately I dont
> have any idea what is cgroup
> subsystem. How to implement cgroup subsystem? Can you give pointers to
> some existing code
> or document? 
Documentation/cgroup/*.txt
Maybe cpuacct cgroup in kernel/sche.c or device cgroup in security/device_cgroup.c
is portable size, but they are not module.
block/blk-cgroup is module and maybe in readable size.

> Also, using this mechanism can we monitor each thread created in
> user space? I.e. it is only a fork handler or even a
> pthread_create/clone can be tracked this way.
> 
please read documents. I think you can.

Thanks,
-Kame

