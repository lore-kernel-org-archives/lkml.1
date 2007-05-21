Return-Path: <linux-kernel-owner+w=401wt.eu-S1759445AbXEUFUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445AbXEUFUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 01:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXEUFU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 01:20:26 -0400
Received: from www.osadl.org ([213.239.205.134]:54871 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754338AbXEUFU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 01:20:26 -0400
Subject: Re: [realtime kernel 2.6.21-rt2 and up] Extremely slow bootup for
	x86_64
From: Thomas Gleixner <tglx@linutronix.de>
To: Frank Sorenson <frank@tuxrocks.com>
Cc: Maarten Maathuis <madman2003@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <46512778.2050205@tuxrocks.com>
References: <6d4bc9fc0705200525m1b72aaaevf8a1d090038bb7dc@mail.gmail.com>
	 <1179669982.21827.25.camel@chaos>  <46512778.2050205@tuxrocks.com>
Content-Type: text/plain
Date: Mon, 21 May 2007 07:26:56 +0200
Message-Id: <1179725216.6570.32.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 00:00 -0500, Frank Sorenson wrote:

> I see the slow bootup as well, even with 2.6.22-rc2-hrt1.  It takes at
> least 5 times as long to boot, for X to start, to login, etc.

Can you provide me your .config and a boot log (please enable
CONFIG_PRINTK_TIME and add "apic=verbose" to the kernel command line).

Can you also try with "hpet=disable" ?

	tglx


