Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbYGHD3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbYGHD3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 23:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbYGHD3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 23:29:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40451 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbYGHD3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 23:29:11 -0400
Date: Tue, 8 Jul 2008 12:31:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/4] Container Freezer: Reuse Suspend Freezer
Message-Id: <20080708123150.3034d83f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080707225823.502032693@us.ibm.com>
References: <20080707225823.502032693@us.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, could I make brief questions ?

On Mon, 07 Jul 2008 15:58:23 -0700
Matt Helsley <matthltc@us.ibm.com> wrote:
> to get status of the freezer subsystem :
> 
>    # cat /containers/0/freezer.state
>    RUNNING
> 
> to freeze all tasks in the container :
> 
>    # echo FROZEN > /containers/0/freezer.state
>    # cat /containers/0/freezer.state
>    FREEZING
>    # cat /containers/0/freezer.state
>    FROZEN
> 
I'm just curious.

1. When we see FREEZING and have to retry ?
   While there are some threads which wait for some event ?

2. What happens when FROZEN threads are moved to other group ?
   Can we move them ?
   Can we wake them up (if it can be moved) ?
   What operations are allowed to frozen threads ?

Thanks,
-Kame

