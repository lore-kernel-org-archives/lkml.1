Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbYIOVPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbYIOVPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbYIOVOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:14:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36445
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757414AbYIOVOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:14:48 -0400
Date: Mon, 15 Sep 2008 14:14:42 -0700 (PDT)
Message-Id: <20080915.141442.139271313.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080915204543.GD3994@havoc.gtf.org>
References: <20080915201749.GB3994@havoc.gtf.org>
	<20080915.132716.267218808.davem@davemloft.net>
	<20080915204543.GD3994@havoc.gtf.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Mon, 15 Sep 2008 16:45:43 -0400

> Don't stick strictly to that list...  We want an oops fix even if
> the oops is present in 2.6.26.  We want a spinlock fix that makes a
> driver work properly on SMP, even if that bug is present in 2.6.26.  We
> want a build fix, etc.

Look at the analysis I just posted.

Most of those changes were complete and utter CRAP.

Build warning fixes, diagnostic message tidyups.  You have
to be kidding me.

Maybe a OOPS fix for common hardware.  But not for something
like obscure WAN stuff.

But otherwise, it is in fact strict by the rules regression
list stuff.  That's all we're fixing now.

And remember it's not you who gets your head chopped off if
I try to merge in stuff that isn't appropriate now.  And Linus
has made it pretty clear what the goals of the non-merge-window
period is, and that is to fix regressions.  Otherwise the process
never comes to closure in a reasonable amount of time.
