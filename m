Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbYFVJv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbYFVJv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 05:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYFVJvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 05:51:16 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:61733 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbYFVJvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 05:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b+YqUNbO55RyriaJb2+/rSK2M2BkYt86Co1757tmddw4EtWQiGUcTAdczuW1JlCMSC
         ByivyKfMRJTeDCxipcR3jt+c4QJ4EriUvTrGPxg225nuVjKfoxwhivepqN+yehA7LJON
         qGC3RCBpUdjhybtnHI5wIYrrQMMdkbpvL9q+o=
Date: Sun, 22 Jun 2008 13:50:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: v2.6.26-rc7/cgroups: circular locking dependency
Message-ID: <20080622095049.GB7285@cvg>
References: <20080621173859.GA6846@damson.getinternet.no> <20080622091013.GA7285@cvg> <19f34abd0806220242p62b9a044la6dd8843e5055f84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806220242p62b9a044la6dd8843e5055f84@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Vegard Nossum - Sun, Jun 22, 2008 at 11:42:50AM +0200]
| On Sun, Jun 22, 2008 at 11:10 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > [Vegard Nossum - Sat, Jun 21, 2008 at 07:38:59PM +0200]
| > |  =======================================================
| > |  [ INFO: possible circular locking dependency detected ]
| > |  2.6.26-rc7 #25
| > |  -------------------------------------------------------
| > |  bash/10032 is trying to acquire lock:
| > |   (&cpu_hotplug.lock){--..}, at: [<c015efbc>] get_online_cpus+0x2c/0x40
| > |
| > |  but task is already holding lock:
| > |   (cgroup_mutex){--..}, at: [<c0160e6f>] cgroup_lock+0xf/0x20
| 
| ...
| 
| > Hi Vegard,
| >
| > would be interesting to see your config please
| 
| Here is my config and vmlinux:
| 
| http://www.kernel.org/pub/linux/kernel/people/vegard/kernels/20080621-v2.6.26-rc7/
| 
| By the way, I was doing CPU hotplug/unplug at the time.
| 
| Thanks :)
| 
| 
| Vegard
| 
| -- 
| "The animistic metaphor of the bug that maliciously sneaked in while
| the programmer was not looking is intellectually dishonest as it
| disguises that the error is the programmer's own creation."
| 	-- E. W. Dijkstra, EWD1036
| 

Thanks Vegard,

actually i'm not that spec in this area ;) but will take a look

		- Cyrill -
