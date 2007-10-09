Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbXJIDmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbXJIDmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 23:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbXJIDmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 23:42:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59735
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753020AbXJIDmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 23:42:42 -0400
Date: Mon, 08 Oct 2007 20:42:36 -0700 (PDT)
Message-Id: <20071008.204236.92016616.davem@davemloft.net>
To: david-b@pacbell.net
Cc: greg@kroah.com, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071009033412.E37E323700C@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20071009031049.GD14127@kroah.com>
	<20071008.201653.43030513.davem@davemloft.net>
	<20071009033412.E37E323700C@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>
Date: Mon, 08 Oct 2007 20:34:12 -0700

> > However, when both OHCI and EHCI are built as modules (or, similarly
> > I guess, OHCI is built-in and EHCI is modular) there appears to be
> > nothing in userspace which makes sure EHCI gets loaded first.
> 
> The old /etc/hotplug/usb.rc script made sure to load those modules
> in the correct order:  EHCI first.

I expected to find something cute attempting to handle this under
/etc/udev, I have failed so far :-)
