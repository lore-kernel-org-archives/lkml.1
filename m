Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYLURYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYLURYm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 12:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYLURYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 12:24:34 -0500
Received: from twin.jikos.cz ([213.151.79.26]:47043 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbYLURYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 12:24:33 -0500
Date: Sun, 21 Dec 2008 18:24:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Parag Warudkar <parag.lkml@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc9: USB Mouse unhappy
In-Reply-To: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0812211823510.11630@twin.jikos.cz>
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2008, Parag Warudkar wrote:

> Just installed today's git on my workstation and my Logitech USB Mouse
> only wants to move vertically around the centre of the monitor.
> I have no clue where to look - all  I know is that it works with the
> 2.6.27 and various 2.6.28-rcs prior to this one.
> [parag@xw6600 ~]$ diff Xorg.0.log.not.working /var/log/Xorg.0.log |grep Logi
> < (**) Logitech USB Receiver: Device: "/dev/input/event5"
> > (**) Logitech USB Receiver: Device: "/dev/input/event6"
> < (II) config/hal: Adding input device Logitech USB Receiver
> < (**) Logitech USB Receiver: always reports core events
> < (**) Logitech USB Receiver: Device: "/dev/input/event3"
> < (II) Logitech USB Receiver: Found x and y relative axes
> < (II) Logitech USB Receiver: Found mouse buttons
> < (II) Logitech USB Receiver: Configuring as mouse
> < (II) XINPUT: Adding extended input device "Logitech USB Receiver"
> (type: MOUSE)

Could you please provide vendor and product IDs of this device? (lsusb -v 
will tell you).

-- 
Jiri Kosina
SUSE Labs

