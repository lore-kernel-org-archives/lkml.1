Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbXH0MKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbXH0MKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbXH0MJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:09:54 -0400
Received: from 193-189-87-45.ip.kis.lt ([193.189.87.45]:30962 "EHLO
	barclay.wilibox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756979AbXH0MJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:09:53 -0400
Subject: Re: Pausing kernel boot messages
From: Zilvinas Valinskas <zilvinas@wilibox.com>
Reply-To: zilvinas@wilibox.com
To: =?ISO-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
Cc: Esteban Fernandez <estfern@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200708271353.22665.hjk@linutronix.de>
References: <179e6e720708270421r5f07f9dfp434077f6a106d2d7@mail.gmail.com>
	 <200708271353.22665.hjk@linutronix.de>
Content-Type: text/plain; charset=utf-8
Date: Mon, 27 Aug 2007 15:09:50 +0300
Message-Id: <1188216590.5361.27.camel@zv.wilibox.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Esteban,

Alternatively, read Documentation/networking/netconsole.txt. Might help
or might not. It depends when system is crashing.

On Mon, 2007-08-27 at 13:53 +0200, Hans-Jürgen Koch wrote:
> Am Montag 27 August 2007 13:21 schrieb Esteban Fernandez:
> > How do you pause the kernel boot messages ?
> > 
> > ^S, Pause and Scroll lock do nothing and you can't Shift-Page-Up  after a
> > kernel panic.
> 
> These are functions of a shell (like bash), which you haven't got yet during
> kernel boot. You can read the kernel boot messages _after_ your system's up
> using dmesg etc.
> If you can't do that, e.g. because your kernel always hangs during boot, you
> could enable a serial console in your kernel and watch/log your kernel 
> messages with a terminal program running on a different computer.
> 
> Hans
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

