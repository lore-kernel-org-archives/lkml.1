Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYAMW5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYAMW5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 17:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYAMW5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 17:57:11 -0500
Received: from gate.crashing.org ([63.228.1.57]:53803 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbYAMW5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 17:57:11 -0500
Subject: Re: [PATCH: 2/2] [SERIAL] avoid stalling suspend if serial port
	won't drain
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080111101721.GA4463@ucw.cz>
References: <20080108115148.GB10546@flint.arm.linux.org.uk>
	 <20080108115703.GA27179@flint.arm.linux.org.uk>
	 <20080111101721.GA4463@ucw.cz>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 09:56:06 +1100
Message-Id: <1200264966.6896.148.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 10:17 +0000, Pavel Machek wrote:
> Is printk() enough for 'we've just lost your data' condition? Maybe we
> should abort suspend if we can't drain fifo?

YUCK !

Ben.


