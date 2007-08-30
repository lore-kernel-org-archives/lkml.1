Return-Path: <linux-kernel-owner+w=401wt.eu-S964847AbXH3TQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847AbXH3TQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 15:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759698AbXH3TPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 15:15:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56558 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759538AbXH3TPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 15:15:52 -0400
Date: Thu, 30 Aug 2007 21:15:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
cc: Andreas Schwab <schwab@suse.de>, Esteban Fernandez <estfern@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Pausing kernel boot messages
In-Reply-To: <200708271413.51368.hjk@linutronix.de>
Message-ID: <Pine.LNX.4.64.0708302115020.24730@fbirervta.pbzchgretzou.qr>
References: <179e6e720708270421r5f07f9dfp434077f6a106d2d7@mail.gmail.com>
 <200708271353.22665.hjk@linutronix.de> <jesl6542a2.fsf@sykes.suse.de>
 <200708271413.51368.hjk@linutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 27 2007 14:13, Hans-Jürgen Koch wrote:
>> >> How do you pause the kernel boot messages ?
>> >> 
>> >> ^S, Pause and Scroll lock do nothing and you can't Shift-Page-Up  after a
>> >> kernel panic.
>> >
>> > These are functions of a shell (like bash),
>> 
>> Definitely not.  The shell is not a console driver, it only uses it.
>
>Right, I wasn't precise. But it's still possible that you don't have your
>keyboard available during early parts of the boot process.

Yes, but a common error is "could not mount root", which is way after the
keyboard has been initialized. *In fact*, you can start initramfs, have your
PgUp/PgDown keys available, and when you exit out of initramfs without a valid
root filesystem, you lose the keys again.


	Jan
-- 
