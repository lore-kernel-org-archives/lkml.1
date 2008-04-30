Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbYD3H26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbYD3H26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYD3H2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:28:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34269 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYD3H2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:28:49 -0400
Date: Wed, 30 Apr 2008 16:33:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       y-goto@jp.fujitsu.com
Subject: Re: sparc64 bootup regression...
Message-Id: <20080430163355.4b4f23ec.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080430.002530.189687792.davem@davemloft.net>
References: <20080429.231241.221824292.davem@davemloft.net>
	<20080429233832.168fb6ee.akpm@linux-foundation.org>
	<20080430161540.bfff2c45.kamezawa.hiroyu@jp.fujitsu.com>
	<20080430.002530.189687792.davem@davemloft.net>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 00:25:30 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Wed, 30 Apr 2008 16:15:40 +0900
> 
> > How about this ? If this is messy (or doesn't work), Goto-san will rework
> > his own patch by himself. (this patch is against -mm but I think no HUNK to
> > git tree)
> 
> This makes the original change pointless.
> 
It seems the orignal change expects NODE_DATA() is allocated at boottime.
not in .bss section.

> If the goal is to put the usemap in the same section as the memory
> itself, in order to allow for it to be freed during memory hotplug,
> this new change just makes the facility not work some of the time.
> 
yes, at least, WARNING is necessary.

> Now maybe sometimes it will work, maybe sometimes it will not.
> 
> It's not the end of the world if this change is reverted for a few
> days while we work out what to do about this.
> 
yes ;)

> Really, it does not reflect badly upon you or Goto-san, if the change
> is reverted temporarily.
> 
Okay, I agree to revert it.

Thanks,
-Kame

