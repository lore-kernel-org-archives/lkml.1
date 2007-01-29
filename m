Return-Path: <linux-kernel-owner+w=401wt.eu-S932735AbXA2W0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735AbXA2W0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932740AbXA2W0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:26:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59436 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735AbXA2W03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:26:29 -0500
Date: Mon, 29 Jan 2007 14:23:59 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: tglx@linutronix.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
Message-ID: <20070129142359.517b1980@freekitty>
In-Reply-To: <1170109401.29240.49.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	<1169931333.17469.125.camel@localhost.localdomain>
	<20070129113159.7ad22e4c@freekitty>
	<1170101430.29240.34.camel@localhost.localdomain>
	<20070129133849.1b523226@freekitty>
	<1170109401.29240.49.camel@localhost.localdomain>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 23:23:21 +0100
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 2007-01-29 at 13:38 -0800, Stephen Hemminger wrote:
> > Sorry it was against the last patch I sent to Jeff for netdev.
> > Here is against 2.6.20-rc6
> 
> Still the same problem. The only difference of this patch to the
> previous version is, that the unhandled interrupt message is gone.
> 
> As I said before:
> 
> Reverting commit 44ade178249fe53d055fd92113eaa271e06acddd, which added
> this hackery in the first place, makes the device survive
> suspend/resume.
> 
> 	tglx
> 
> 

But the fix is necessary on laptops where ACPI messes with MSI/INTx
on resume.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
