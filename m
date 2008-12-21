Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbYLUGNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbYLUGNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 01:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbYLUGM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 01:12:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827AbYLUGM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 01:12:56 -0500
Date: Sat, 20 Dec 2008 22:12:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Parag Warudkar" <parag.lkml@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.28-rc9: USB Mouse unhappy
Message-Id: <20081220221253.e09b1b1f.akpm@linux-foundation.org>
In-Reply-To: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com>
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Sat, 20 Dec 2008 22:11:17 -0500 "Parag Warudkar" <parag.lkml@gmail.com> wrote:

> Just installed today's git on my workstation and my Logitech USB Mouse
> only wants to move vertically around the centre of the monitor.
> 
> I have no clue where to look - all  I know is that it works with the
> 2.6.27 and various 2.6.28-rcs prior to this one.
> 
> Parag
> 
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
> > (II) config/hal: Adding input device Logitech USB Receiver
> > (**) Logitech USB Receiver: always reports core events
> > (**) Logitech USB Receiver: Device: "/dev/input/event5"
> > (II) Logitech USB Receiver: Found x and y relative axes
> > (II) Logitech USB Receiver: Found mouse buttons
> > (II) Logitech USB Receiver: Configuring as mouse
> > (II) XINPUT: Adding extended input device "Logitech USB Receiver" (type: MOUSE)

Could be input, could be HID, could even be USB.

You're sure that 2.6.28-rc8 was OK?

2.6.28-rc9 had only a small number of changes.  Nothing I can see in
input or HID.  A few USB changes, but pretty specific ones -
unusual_devs entries and such.

Maybe your mouse has died?  Did you retest with an older kernel?
