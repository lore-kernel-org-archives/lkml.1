Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbXIYHBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbXIYHBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 03:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbXIYHBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 03:01:08 -0400
Received: from tag.witbe.net ([81.88.96.48]:42152 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbXIYHBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 03:01:07 -0400
Date: Tue, 25 Sep 2007 09:00:57 +0200
From: Paul Rolland <rol@as2917.net>
To: David Newall <david@davidnewall.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>, rol@witbe.net
Subject: Re: 2.6.23-rc7 - _random_ IRQ23 : nobody cared
Message-ID: <20070925090057.5778aa2a@tux.DEF.witbe.net>
In-Reply-To: <46F7C933.4080003@davidnewall.com>
References: <20070924083336.7a08fd61@tux.DEF.witbe.net>
	<46F7C933.4080003@davidnewall.com>
Organization: AS2917.net
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, 24 Sep 2007 23:56:59 +0930
David Newall <david@davidnewall.com> wrote:

> Paul Rolland "(???????) wrote:
> > Hell, IRQ 23 is shared between libata and my modem !!!
> >   
> 
> Tried using the modem?

When no problem is reported, both the libata part and the modem are OK.
When the problem is reported, at that time, only libata is handling IRQ23
(the modem is a WinModem, and the driver is an out-kernel module), this 
is still kernel boot time, and the disabling of the IRQ makes my machine
unable to complete the boot process (too many disk timeout).

It could be good to be able to delay the disabling of an IRQ something long
enough to allow all the modules to be loaded...

Paul

