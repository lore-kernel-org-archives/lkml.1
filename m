Return-Path: <linux-kernel-owner+w=401wt.eu-S1762594AbZE2QeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762594AbZE2QeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 12:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbZE2Qdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 12:33:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZE2Qdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 12:33:54 -0400
Date: Fri, 29 May 2009 12:33:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: GeunSik Lim <leemgs1@gmail.com>
cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       trivial@kernel.org, balagi@justmail.de, bgamari@gmail.com,
       Ingo Molnar <mingo@elte.hu>, inaky.perez-gonzalez@intel.com
Subject: Re: [RFC V2 PATCH]debugfs:Fix terminology inconsistency of dir name
 to mount debugfs filesystem.
In-Reply-To: <alpine.DEB.2.00.0905291217470.31247@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0905291233190.31247@gandalf.stny.rr.com>
References: <1243315163.14685.17.camel@centos51> <1243613134.20635.14.camel@centos51> <alpine.DEB.2.00.0905291217470.31247@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 29 May 2009, Steven Rostedt wrote:
> ===
> When debugfs is configured into the kernel (which selecting any ftrace 
> option will do) the directory /sys/kernel/debug will be created. To mount 
> this directory, you can add to your /etc/fstab file:
> 
>   debugfs	/debug		debugfs	defaults	0	0

s,/debug,/sys/kernel/debug,

> 
> Or you can mount it at run time with:
> 
>   mount -t debugfs nodev /sys/kernel/debug
> 
> For quicker access to that directory you may want to make a soft link to 
> it:
> 
>  ln -s /sys/kernel/debug /debug
> 
> Any selected ftrace option will also create a directory called tracing 
> within the debugfs. The rest of the document will assume that you are in 
> the ftrace directory (cd /sys/kernel/debugfs) and will only concentrate
> on the files within that directory and not distract from the content with 
> the extended "/sys/kernel/debug/tracing" path name.
> ===

-- Steve

