Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbYKPQeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbYKPQeq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbYKPQeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:34:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42545 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774AbYKPQeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:34:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Gioacchino Mendola" <gioacchino.mendola@gmail.com>
Subject: Re: Fwd: Problem with kernel 2.6.27.5
Date: Sun, 16 Nov 2008 17:39:00 +0100
User-Agent: KMail/1.9.9
Cc: kernel-testers@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <42c6aeaf0811160721t7ef23e66i21448fe5f49afa1b@mail.gmail.com> <42c6aeaf0811160726j7e17d6e4u589ce8d945962108@mail.gmail.com>
In-Reply-To: <42c6aeaf0811160726j7e17d6e4u589ce8d945962108@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811161739.01179.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(General question, CCing LKML).

On Sunday, 16 of November 2008, Gioacchino Mendola wrote:
> ---------- Forwarded message ----------
> From: Gioacchino Mendola <gioacchino.mendola@gmail.com>
> Date: 2008/11/16
> Subject: Problem with kernel 2.6.27.5
> To: majordomo@vger.kernel.org
> 
> 
> Hello everyone,
> This is my first mail and I hope my questions will not be too trivial!
> I'm trying to develop a  lodable kernel module but I have a problems
> with certain system functions that have been deprecated.
> With the previuos kernel(2.6.26), I used the following functions
> 
> kill_proc(pid_t pid, int sig, int priv)
> 
> find_task_by_pid(int pid)
> 
> Now i use the linux kernel 2.6.27.5
> 
> Instead of kill_proc I tried to use kill_pid.
> Kill_pid() requires as a first argument  a struct pid  and not a pid_t pid.
> 
> kill_pid(struct pid *pid, int sig, int priv)
> 
> how can I get "struct pid" by "pid_t pid"?
> 
> how can I get the "task_struct" by the pid?
> 
> Thanks in advance
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-testers" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



-- 
Everyone knows that debugging is twice as hard as writing a program
in the first place.  So if you're as clever as you can be when you write it,
how will you ever debug it? --- Brian Kernighan
