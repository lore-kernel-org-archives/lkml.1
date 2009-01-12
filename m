Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbZALPsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbZALPsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbZALPsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:48:31 -0500
Received: from matrixpower.ru ([195.178.208.66]:39505 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbZALPsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:48:30 -0500
Date: Mon, 12 Jan 2009 18:48:27 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090112154827.GB20743@ioremap.net>
References: <20090112153304.GA19995@ioremap.net> <20090112154456.GA27269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112154456.GA27269@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave.

On Mon, Jan 12, 2009 at 10:44:56AM -0500, Dave Jones (davej@redhat.com) wrote:
>  > Do you want to own a tame killer? Do you want to control the world?
>  > 
>  > Start with your computer now and own the planet next: you already have
>  > an OOM-killer in the Linux to kill for you. But to date it was quite
>  > berserk and usually killed not what you would like him to murder.
>  > 
>  > Now you can add a name of the victims, which will be checked by the
>  > oom-killer, who select the process to kill first among the ones which
>  > have given string in their executable name.
>  > 
>  > By default the process to be killed is called 'Kenny', and if you like
>  > him, change then name by calling
> 
> I realise it ruins the joke, and it sounds unlikely, but anyone who
> happens to have a process called 'Kenny' might be unpleasantly surprised
> by this.
> 
> If we merge this feature, I think it should default to just using the
> existing heuristic.

Well, Kenny has to die, but if we still decide to change the world, here
is the fist step.

--- ./mm/oom_kill.c~	2009-01-12 17:51:23.000000000 +0300
+++ ./mm/oom_kill.c	2009-01-12 18:48:04.000000000 +0300
@@ -28,7 +28,7 @@
 #include <linux/memcontrol.h>
 #include <linux/security.h>
 
-char oom_victim_name[TASK_COMM_LEN] = "Kenny";
+char oom_victim_name[TASK_COMM_LEN] = "";
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;


-- 
	Evgeniy Polyakov
