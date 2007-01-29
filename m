Return-Path: <linux-kernel-owner+w=401wt.eu-S932518AbXA2WWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbXA2WWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbXA2WWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:22:42 -0500
Received: from www.osadl.org ([213.239.205.134]:33878 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752619AbXA2WWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:22:41 -0500
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <20070129133849.1b523226@freekitty>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	 <1169931333.17469.125.camel@localhost.localdomain>
	 <20070129113159.7ad22e4c@freekitty>
	 <1170101430.29240.34.camel@localhost.localdomain>
	 <20070129133849.1b523226@freekitty>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 23:23:21 +0100
Message-Id: <1170109401.29240.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 13:38 -0800, Stephen Hemminger wrote:
> Sorry it was against the last patch I sent to Jeff for netdev.
> Here is against 2.6.20-rc6

Still the same problem. The only difference of this patch to the
previous version is, that the unhandled interrupt message is gone.

As I said before:

Reverting commit 44ade178249fe53d055fd92113eaa271e06acddd, which added
this hackery in the first place, makes the device survive
suspend/resume.

	tglx


