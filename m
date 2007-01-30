Return-Path: <linux-kernel-owner+w=401wt.eu-S965118AbXA3AY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965118AbXA3AY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 19:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965101AbXA3AY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 19:24:28 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34976 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965015AbXA3AY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 19:24:26 -0500
Date: Mon, 29 Jan 2007 16:21:53 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: tglx@linutronix.de
Cc: =?UTF-8?B?RnLDqWTDqXJpYw==?= Riss <frederic.riss@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] block MSI on Sony
Message-ID: <20070129162153.6b3b5eff@freekitty>
In-Reply-To: <1170116575.29240.114.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	<1169931333.17469.125.camel@localhost.localdomain>
	<20070129113159.7ad22e4c@freekitty>
	<1170101430.29240.34.camel@localhost.localdomain>
	<20070129133849.1b523226@freekitty>
	<1170109401.29240.49.camel@localhost.localdomain>
	<1170110318.21603.25.camel@funkylaptop>
	<1170110732.29240.59.camel@localhost.localdomain>
	<1170111056.21603.30.camel@funkylaptop>
	<1170111464.29240.63.camel@localhost.localdomain>
	<1170113200.21603.41.camel@funkylaptop>
	<1170113879.29240.79.camel@localhost.localdomain>
	<20070129155043.56a1c577@freekitty>
	<1170116575.29240.114.camel@localhost.localdomain>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 01:22:54 +0100
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 2007-01-29 at 15:50 -0800, Stephen Hemminger wrote:
> > The Sony VAIO BIOS resets to INTx on resume. This happens
> > after device resume, so device irq's get misrouted.
> 
> Err? My Sony VAIO does _NOT_ do that. It works fine without that. 
> It's just the sky2 hackery which fucked up things.
> 

What machine and BIOS version?


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
