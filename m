Return-Path: <linux-kernel-owner+w=401wt.eu-S934931AbXEMQrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934931AbXEMQrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934922AbXEMQrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:47:16 -0400
Received: from www.osadl.org ([213.239.205.134]:43274 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934903AbXEMQrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:47:14 -0400
Subject: Re: [patch] make pit clocksource continuous
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46474175.7030205@aknet.ru>
References: <46464B5C.2080302@aknet.ru>
	 <1179040612.22481.237.camel@localhost.localdomain>
	 <4646D493.9000309@aknet.ru>
	 <1179068094.22481.248.camel@localhost.localdomain>
	 <46474175.7030205@aknet.ru>
Content-Type: text/plain
Date: Sun, 13 May 2007 18:50:25 +0200
Message-Id: <1179075026.22481.273.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-13 at 20:48 +0400, Stas Sergeev wrote:
> Hello.
> 
> Thomas Gleixner wrote:
> > You need either pm_timer or hpet in order to switch to highres /
> > dynticks. Are those enabled in the kernel config ?
> Yes, both were enabled.
> However, since this board is very old
> (bios is dated 2000), I had "acpi=off".
> Now removing that, makes the hrtimers to
> work.
> Does this mean that on even an older
> boards (without acpi at all) the hrtimers
> won't work?

Not if PIT is the only clocksource available.

	tglx


