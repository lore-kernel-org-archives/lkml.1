Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbXLCKeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbXLCKeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 05:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbXLCKd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 05:33:57 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39856 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbXLCKd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 05:33:56 -0500
Date: Mon, 3 Dec 2007 11:35:57 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20071203103557.GT10305@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: heartbeat for leds on i2c bus
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

on my custom board I have some leds mapped on a dedicated chip
connected via i2c bus.

If I try to use the heartbeat trigger I hang the system... I suppose
it is due the fact the led_set_brightness() function is called inside
a kernel timer.

How I can solve this problem? I thought to modify the trigger adding a
kernel thread who manage the led which in turn is controlled by the
kernel timer. It could be the right solution?

Thanks in advance,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
