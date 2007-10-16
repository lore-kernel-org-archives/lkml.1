Return-Path: <linux-kernel-owner+w=401wt.eu-S936398AbXJPWGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936398AbXJPWGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965931AbXJPWG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:06:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39529
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965872AbXJPWG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:06:26 -0400
Date: Tue, 16 Oct 2007 15:06:31 -0700 (PDT)
Message-Id: <20071016.150631.122031826.davem@davemloft.net>
To: stern@rowland.harvard.edu
Cc: david-b@pacbell.net, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.44L0.0710161107510.4418-100000@iolanthe.rowland.org>
References: <20071015.165828.59656315.davem@davemloft.net>
	<Pine.LNX.4.44L0.0710161107510.4418-100000@iolanthe.rowland.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>
Date: Tue, 16 Oct 2007 11:23:58 -0400 (EDT)

> Unfortunately that simply isn't possible.  No matter what you do, the 
> user can always unload ehci-hcd and then load it back in again.

Yes we can, by making OHCI and EHCI one module with a top-level
dispatch.  If you enable both OHCI and EHCI, the top-level
module will dispatch the host initializations in the correct order.

This is what I've suggested from the beginning.
