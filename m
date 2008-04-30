Return-Path: <linux-kernel-owner+w=401wt.eu-S1761803AbYD3Hwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761803AbYD3Hwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758219AbYD3Hwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:52:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38200
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756787AbYD3Hwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:52:38 -0400
Date: Wed, 30 Apr 2008 00:52:37 -0700 (PDT)
Message-Id: <20080430.005237.104034287.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for April 30
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080430173743.ce1c9784.sfr@canb.auug.org.au>
References: <20080430173104.39897492.sfr@canb.auug.org.au>
	<20080430.003447.200525841.davem@davemloft.net>
	<20080430173743.ce1c9784.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 30 Apr 2008 17:37:43 +1000

> On Wed, 30 Apr 2008 00:34:47 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> > No, I'm seeing allmodconfig builds fail even with a clean tree.  It's
> > from the recent v4l/dvb merge and I'm bisecting now.
> 
> Thanks, Dave.  But don't you have enough to do? :-)

Bisecting regressions appears to be my new full-time job. :-/

> reverting 149ef72deeba57078216c9fa678baff392295853 makes it build for
> me ...

Ingo just reported a similar one, which is actually the one I was
triggering, I've CC:'d you there.
