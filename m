Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbXGGHih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbXGGHih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 03:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbXGGHi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 03:38:29 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:51827 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbXGGHi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 03:38:29 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Sat, 7 Jul 2007 13:30:15 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Joel Becker <Joel.Becker@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Teigland <teigland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [PATCH] configfs: Convert subsystem semaphore to mutex
In-Reply-To: <20070707063615.GA23394@ca-server1.us.oracle.com>
Message-ID: <Pine.LNX.4.64.0707071320400.24470@cselinux1.cse.iitk.ac.in>
References: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070704110711.28503.26591.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070707063615.GA23394@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joel,

On Fri, 6 Jul 2007, Joel Becker wrote:
> [Rewritten so that it applies to mainline and names the filed su_mutex.
>  This will appear in my tree.]

The one I'd sent was diffed against -mm, which includes gfs2-2.6-fixes.git
but apparently Linus' tree (I just checked -rc7, at least) doesn't seem
to have merged in gfs2-2.6-fixes.git as yet. There are references to
down() / up() / su_sem / config_group_find_obj() in there (which was why
I had diffed against -mm to cover all the uses of these), so those will
have to be updated accordingly as well now ...

> Convert the su_sem member of struct configfs_subsystem to a struct
> mutex, as that's what it is. Also convert all the users and update
> Documentation/configfs.txt and Documentation/configfs_example.c
> accordingly.
> 
> Inspired-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>

With that caveat, Acked-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

Satyam
