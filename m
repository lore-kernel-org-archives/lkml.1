Return-Path: <linux-kernel-owner+w=401wt.eu-S1758371AbZEZUo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbZEZUo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbZEZUou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:44:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65392 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbZEZUou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:44:50 -0400
Date: Tue, 26 May 2009 16:44:49 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: GeunSik Lim <leemgs1@gmail.com>
cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       trivial@kernel.org, balagi@justmail.de, bgamari@gmail.com,
       Ingo Molnar <mingo@elte.hu>, inaky.perez-gonzalez@intel.com
Subject: Re: [RFC PATCH]debugfs:Fix terminology inconsistency of dir name to
 mount debugfs filesystem.
In-Reply-To: <1243315163.14685.17.camel@centos51>
Message-ID: <alpine.DEB.2.00.0905261642130.26705@gandalf.stny.rr.com>
References: <1243315163.14685.17.camel@centos51>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 26 May 2009, GeunSik Lim wrote:

> 
> 
>  Hi all, 
>    
>  I want to hear your opinions about this proposal for consistency of
>  mount directory to mount debugfs filesystem that need  by ftrace infrastructure.
>  Um... I appended "RFC" word in the subject because this mail is my proposal just.  
> 
> 
> commit 1766a83645706100b1829bb422f852ec757c6f4b
> Author: GeunSik,Lim <leemgs1@gmail.com>
> Date:   Tue May 26 13:49:23 2009 +0900
> 
>     Fix terminology inconsistency of dir name to mount debugfs filesystem.
>     
>       Many developers use "/debug/" directory name to mount debugfs filesystem
>       for ftrace according to ./Documentation/tracers/ftrace.txt file.
>     
>       But, two directory names(ex:/debug/, /debugfs/) is existed in kernel source
>       like ftrace, DRM, Wireless, Network[sky2]files to mount debugfs filesystem.
>       I think that we don't have to select either "/debug/" directory name or
>       "/debugfs/" directory name for terminology consistency.
>     
>       debugfs means debug filesystem for debugging easy to use by greg kroah
>       hartman. "/debug/" name is suitable as directory name of debugfs for
>       tracing using ftrace like "/sys/" of sysfs(system filesystem).
>       -debugfs related reference: http://lwn.net/Articles/115405/
>     
>       Fix inconsistency of directory name according to duplicated expression
>       to mount debugfs.
>     
>          Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>

I'm guilty of using both /debug and /debugfs in comments. In practice, I 
only use /debug.

But...

The filesystem Nazi's out there will argue that the proper place to mount 
the debugfs filesystem is /sys/kernel/debug. I personally find that 
location annoying.

-- Steve

