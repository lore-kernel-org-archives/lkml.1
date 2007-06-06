Return-Path: <linux-kernel-owner+w=401wt.eu-S1759930AbXFFJ2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbXFFJ2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbXFFJ2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:28:43 -0400
Received: from hansmi.home.forkbomb.ch ([213.144.146.165]:7486 "EHLO
	hansmi.home.forkbomb.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbXFFJ2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:28:42 -0400
Date: Wed, 6 Jun 2007 11:28:37 +0200
From: Michael Hanselmann <linux-kernel@hansmi.ch>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel@killerfox.forkbomb.ch
Subject: Re: [linux-usb-devel] [PATCH] Fix NEC OHCI chip silicon bug
Message-ID: <20070606092837.GA19712@hansmi.ch>
References: <20070604210555.GB12676@hansmi.ch> <Pine.LNX.4.44L0.0706051018360.3662-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0706051018360.3662-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 10:24:14AM -0400, Alan Stern wrote:
> (Depending on which version of the kernel you are looking at -- [...]
> Earlier versions did behave the way you describe.)

I was looking at 2.6.22-rc3 which might explain the differences.

> So the system is behaving the way you want, but not for the reason you 
> think.  I bet you could remove the call to usb_root_hub_lost_power() 
> entirely and it wouldn't make any difference at all.

Actually, that's true. René Nussbaumer tried without that call and it
still works as intended. Should I leave that call out and drop the
changes on usb_root_hub_lost_power for CONFIG_PM?

Greets,
Michael
