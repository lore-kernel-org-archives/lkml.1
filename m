Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbXL3Mr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbXL3Mr2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 07:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXL3MrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 07:47:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58696 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbXL3MrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 07:47:18 -0500
Date: Sun, 30 Dec 2007 13:48:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       hpa@zytor.com, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230124852.GA30836@one.firstfloor.org>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers that then are shown to really need it could use their *own* ports.

The i8259 driver uses it and it is known to be needed on some old chipsets.
But it doesn't really have any "own" ports to use afaik.

-Andi
