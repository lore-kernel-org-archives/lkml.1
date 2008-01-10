Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbYAJCZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbYAJCZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYAJCZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:25:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:8418 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbYAJCZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:25:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qdMXb1/Z5OJ9lDWAxVYz6wLH1Hl59DhFS31i/7rWYdI0t1Md5LW8o+wjDqSN+zdfEtNn73G2QmLkfF/4WQX9TyL4scXrOhhPpIlXWoCsGhphqlfK+R1HSKqUbE6zogUgXu3W/62WuDk3Mb2nJR9deBQwguDD9LeGXQ20IjV51So=
Message-ID: <91b13c310801091825q5d763ff8if6463edba0c9e587@mail.gmail.com>
Date: Thu, 10 Jan 2008 10:25:26 +0800
From: "rae l" <crquan@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] PROC_FS: get and set the smp affinity of tasks by read-write /proc/<pid>/smp_affinity
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, emdow@us.ibm.com
In-Reply-To: <20080109163350.79a4c346.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199430221-28417-1-git-send-email-crquan@gmail.com>
	 <20080109163350.79a4c346.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 10, 2008 8:33 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri,  4 Jan 2008 15:03:41 +0800
> Denis Cheng <crquan@gmail.com> wrote:
>
> > this adds a read-write /proc/<pid>/smp_affinity entry,
> > just like what /proc/irq/<irq>/smp_affinity does,
> > so now we can get and set the affinity of tasks by procfs,
> > this is especially useful used in shell scripts.
> >
> > this also adds a read-write /proc/<pid>/tasks/<tid>/smp_affinity
> > for the same purpose.
>
> Why not use /usr/bin/taskset?
I know /usr/bin/tasklet is another way to set smp affinity of a task,
it uses the sched_{set,get}affinity system call binary interface, but
add a /proc/<pid>/smp_affinity could give a new choice; and this keeps
consistency with /proc/irq/<irq>/smp_affinity, will be familiar to
most people.

Another way, the sysctl system call binary interface has been marked
deprecated recently, only /proc/sys/ operating interface left; I
wonder this this would be a tendency of virtual filesystem interface
to replace binary interface? In my opinion, vfs text interface is
always better than system call binary interface.

>

-- 
Denis Cheng
