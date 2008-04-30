Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbYD3Myd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbYD3Myd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760665AbYD3MyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:54:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41559 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149AbYD3Mxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:53:54 -0400
Date: Wed, 30 Apr 2008 21:53:18 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: David Miller <davem@davemloft.net>
Subject: Re: sparc64 bootup regression...
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080430163355.4b4f23ec.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080430.002530.189687792.davem@davemloft.net> <20080430163355.4b4f23ec.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080430213831.F808.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 30 Apr 2008 00:25:30 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Date: Wed, 30 Apr 2008 16:15:40 +0900
> > 
> > > How about this ? If this is messy (or doesn't work), Goto-san will rework
> > > his own patch by himself. (this patch is against -mm but I think no HUNK to
> > > git tree)
> > 
> > This makes the original change pointless.
> > 
> It seems the orignal change expects NODE_DATA() is allocated at boottime.
> not in .bss section.
> 
> > If the goal is to put the usemap in the same section as the memory
> > itself, in order to allow for it to be freed during memory hotplug,
> > this new change just makes the facility not work some of the time.
> > 
> yes, at least, WARNING is necessary.
> 
> > Now maybe sometimes it will work, maybe sometimes it will not.
> > 
> > It's not the end of the world if this change is reverted for a few
> > days while we work out what to do about this.
> > 
> yes ;)
> 
> > Really, it does not reflect badly upon you or Goto-san, if the change
> > is reverted temporarily.
> > 
> Okay, I agree to revert it.

David-san.
Thanks for your report. I agree to revert it too.
I'll reconsider around here.

Unfortunately, I can't access my box to make newer patch until 5/11,
because I'm on vacation. Probably, I'm not able to post
newer patch in merge window....  Oh my..... :-(

Bye.

-- 
Yasunori Goto 


