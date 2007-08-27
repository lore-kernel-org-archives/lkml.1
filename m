Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbXH0Lxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbXH0Lxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 07:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXH0Lx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 07:53:28 -0400
Received: from www.osadl.org ([213.239.205.134]:34382 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750723AbXH0Lx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 07:53:27 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: "Esteban Fernandez" <estfern@gmail.com>
Subject: Re: Pausing kernel boot messages
Date: Mon, 27 Aug 2007 13:53:22 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <179e6e720708270421r5f07f9dfp434077f6a106d2d7@mail.gmail.com>
In-Reply-To: <179e6e720708270421r5f07f9dfp434077f6a106d2d7@mail.gmail.com>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708271353.22665.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 27 August 2007 13:21 schrieb Esteban Fernandez:
> How do you pause the kernel boot messages ?
> 
> ^S, Pause and Scroll lock do nothing and you can't Shift-Page-Up  after a
> kernel panic.

These are functions of a shell (like bash), which you haven't got yet during
kernel boot. You can read the kernel boot messages _after_ your system's up
using dmesg etc.
If you can't do that, e.g. because your kernel always hangs during boot, you
could enable a serial console in your kernel and watch/log your kernel 
messages with a terminal program running on a different computer.

Hans

