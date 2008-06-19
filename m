Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbYFSVls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbYFSVls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYFSVlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:41:39 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:42539 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYFSVlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:41:39 -0400
Date: Thu, 19 Jun 2008 14:17:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       josh@freedesktop.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       dino@in.ibm.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, vegard.nossum@gmail.com,
       adobriyan@gmail.com, oleg@tv-sign.ru, bunk@kernel.org, rjw@sisk.pl
Subject: Re: [PATCH] Make rcutorture more vicious: reinstate boot-time
 testing
Message-Id: <20080619141725.2d231fc1.randy.dunlap@oracle.com>
In-Reply-To: <20080619155854.GA5084@linux.vnet.ibm.com>
References: <20080618122144.GA27143@linux.vnet.ibm.com>
	<20080618162649.GA18326@linux.vnet.ibm.com>
	<20080619092914.GB15228@elte.hu>
	<20080619155854.GA5084@linux.vnet.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008 08:58:54 -0700 Paul E. McKenney wrote:

> On Thu, Jun 19, 2008 at 11:29:14AM +0200, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > Hello again!
> > > 
> 
>  Documentation/RCU/torture.txt      |   21 
>  Documentation/RCU/torture.txt.orig |    8 
                                ~~~~~

>  kernel/rcutorture.c                |   14 
>  kernel/rcutorture.c.orig           |   59 
                       !!!!

>  kernel/sysctl.c                    |   13 
>  kernel/sysctl.c.orig               | 2851 +++++++++++++++++++++++++++++++++++++
                   ~~~~

>  lib/Kconfig.debug                  |   20 
>  lib/Kconfig.debug.orig             |  679 ++++++++
                     ~~~~

What's with all of these .orig files, eh??


>  8 files changed, 3651 insertions(+), 14 deletions(-)


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
