Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbZE2QsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbZE2QsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 12:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbZE2QsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 12:48:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35397 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZE2QsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 12:48:06 -0400
Date: Fri, 29 May 2009 12:48:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: GeunSik Lim <leemgs1@gmail.com>
cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       trivial@kernel.org, balagi@justmail.de, bgamari@gmail.com,
       Ingo Molnar <mingo@elte.hu>, inaky.perez-gonzalez@intel.com
Subject: Re: [RFC V2 PATCH]debugfs:Fix terminology inconsistency of dir name
 to mount debugfs filesystem.
In-Reply-To: <1243613134.20635.14.camel@centos51>
Message-ID: <alpine.DEB.2.00.0905291240150.31247@gandalf.stny.rr.com>
References: <1243315163.14685.17.camel@centos51> <1243613134.20635.14.camel@centos51>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Sat, 30 May 2009, GeunSik Lim wrote:

> 
> 
> Dear Greg and Steen,
> 
> Thanks your advices and opinions about a confusion according to  
> too many mount directory names for debugfs. I made rfc v2 patch file again like belows.
> Can I hear your advices about below patch contents?.  
> 
> * ref: 
> http://groups.google.com/group/linux.kernel/browse_thread/thread/c34e386587979340/dc52317f888e78b6?#dc52317f888e78b6
> 
> 
> Regards,
> GeunSik Lim.
> 
> Subject: [PATCH]   Fix terminology inconsistency of dir name to mount debugfs filesystem.
> 
>       Many developers use "/debug/" or "/debugfs/ directory name to mount
>       debugfs filesystem for ftrace according to
>       ./Documentation/tracers/ftrace.txt file.
> 
>       And, three directory names(ex:/debug/, /debugfs/, /sys/kernel/debug/) is
>       existed in kernel source like ftrace, DRM, Wireless, Network[sky2]files
>       to mount debugfs filesystem.
> 
>       debugfs means debug filesystem for debugging easy to use by greg kroah
>       hartman. "/sys/kernel/debug/" name is suitable as directory name
>       of debugfs filesystem.
>       -debugfs related reference: http://lwn.net/Articles/115405/

Note, LWN has an update this week:

 http://lwn.net/Articles/334546/

But it currently is subscriber only. Others would need to either buy a 
subscription (plug) or wait a week for it to become open.

Still for some aspects, just having "debugfs" without the leading "/" 
might just be self explanatory. We can assume the user already knows where 
debugfs is mounted.

-- Steve


> 
>       Fix inconsistency of directory name to mount debugfs filesystem.
> 
>          Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
>          Acked-By: Inaky Perez-Gonzalez <inaky@linux.intel.com>
>          CC: Greg KH <greg@kroah.com>
>          CC: Steven Rostedt <rostedt@goodmis.org>
>          CC: linux-kernel <linux-kernel@vger.kernel.org>
