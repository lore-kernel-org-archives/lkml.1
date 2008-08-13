Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYHMTxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYHMTxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYHMTxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:53:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39525 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYHMTxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:53:43 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <srostedt@redhat.com>, Bruce Duncan <bwduncan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] ftrace for v2.6.27
From: Andi Kleen <andi@firstfloor.org>
References: <20080714142226.GA11412@elte.hu>
	<200808130248.58216.bwduncan@gmail.com> <48A2F9AB.8000608@redhat.com>
	<20080813151827.GA10819@elte.hu>
Date: Wed, 13 Aug 2008 21:53:41 +0200
In-Reply-To: <20080813151827.GA10819@elte.hu> (Ingo Molnar's message of "Wed, 13 Aug 2008 17:18:27 +0200")
Message-ID: <873al81yka.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> try latest tip/master plus an USB debug key, then enable 
> CONFIG_EARLY_PRINTK_DBGP=y in your .config on the host, add the 
> earlyprintk=dbgp,keep boot parameter and reboot [and disable USB for 
> good measure]. On the other host you connect to via an USB cable, enable 
> USB_SERIAL_DEBUG=y and use /dev/ttyUSB0 with the serial terminal app of 
> your choice.
>
> that, as long as the USB ports are operational, gives a working serial 
> console on just about any laptop.

Unfortunately the usb debug dongle cables are hard to get and
expensive. A more available alternative would be to use firescope if
your laptop has firewire, because firewire cables are widely
available. The kernel supports early firewire since some time too, so
it can be even used for early debugging. Another advantage is that
firescope can even get data from a dead kernel as long as the firewire
hardware is not disabled.

For details see Documentation/debugging-via-ohci1394.txt

-Andi
