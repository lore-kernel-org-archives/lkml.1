Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab0BOXDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 18:03:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702Ab0BOXDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 18:03:15 -0500
Date: Mon, 15 Feb 2010 18:02:48 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, gorcunov@gmail.com,
       aris@redhat.com
Subject: Re: [PATCH 1/4] nmi_watchdog: use a boolean config flag for compiling
Message-ID: <20100215230248.GP3062@redhat.com>
References: <1266013161-31197-1-git-send-email-dzickus@redhat.com>
 <20100214165941.GA26329@elte.hu>
 <20100214181219.GA27839@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100214181219.GA27839@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 07:12:19PM +0100, Ingo Molnar wrote:
> 
> i'm also getting this:
> 
> [   11.101892] NET: Registered protocol family 5
> [   19.293996] INFO: RCU detected CPU stalls: 1 (detected by 0, t=10002 jiffies)

I guess part of the problem I am having trouble reproducing this is
because I am not sure where you are getting the config from that you send
me.  Above clearly shows RCU has stall detetion on but the config you
provided me has:

# CONFIG_RCU_CPU_STALL_DETECTOR is not set

I guess I assumed I could just plug the config files you gave me into the
source tree.  Perhaps I misunderstood your intentions?

Cheers,
Don
