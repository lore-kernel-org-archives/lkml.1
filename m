Return-Path: <linux-kernel-owner+w=401wt.eu-S1750780AbXBKS2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750780AbXBKS2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 13:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbXBKS2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 13:28:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44333
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbXBKS2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 13:28:54 -0500
Date: Sun, 11 Feb 2007 10:28:52 -0800 (PST)
Message-Id: <20070211.102852.45510952.davem@davemloft.net>
To: lunz@falooley.org
Cc: olaf@aepfle.de, rol@witbe.net, akpm@osdl.org, linux-kernel@vger.kernel.org,
       rol@as2917.net
Subject: Re: [PATCH] keep track of network interface renaming
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070211182704.GA14021@avocado.homenet>
References: <20070211125423.GA30668@aepfle.de>
	<20070211.095552.71093127.davem@davemloft.net>
	<20070211182704.GA14021@avocado.homenet>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Lunz <lunz@falooley.org>
Date: Sun, 11 Feb 2007 13:27:05 -0500

> On Sun, Feb 11, 2007 at 09:55:52AM -0800, David Miller wrote:
> > This is kernel log clutter.
> > 
> > You can ask the kernel for the list of interfaces, and
> > use even ethtool to ask what driver each interface is
> > associated with.
> > 
> > The patch wasn't applied because it really is not necessary.
> 
> I disagree completely. I'm working right now on a udev-based system that
> does ethernet device renaming. It's quite difficult when working with
> udev to tell exactly when and why each interface was renamed, since it's
> typically done within initramfs where it's difficult to enable debug
> messages. This printk helps immensely.

You can listen on a netlink socket for these events if you
want to see when they occur.

There is no need for this log message, it is superfluous.
