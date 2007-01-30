Return-Path: <linux-kernel-owner+w=401wt.eu-S965135AbXA3A0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965135AbXA3A0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 19:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965137AbXA3A0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 19:26:03 -0500
Received: from www.osadl.org ([213.239.205.134]:58110 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965129AbXA3AZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 19:25:59 -0500
Subject: Re: [PATCH] block MSI on Sony
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org
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
Content-Type: text/plain
Date: Tue, 30 Jan 2007 01:26:40 +0100
Message-Id: <1170116800.29240.118.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-30 at 01:22 +0100, Thomas Gleixner wrote:
> On Mon, 2007-01-29 at 15:50 -0800, Stephen Hemminger wrote:
> > The Sony VAIO BIOS resets to INTx on resume. This happens
> > after device resume, so device irq's get misrouted.
> 
> Err? My Sony VAIO does _NOT_ do that. It works fine without that. 
> It's just the sky2 hackery which fucked up things.

And how is this going to solve the breakage on Frederics box?

> I see the same symptoms on my Intel Mac Mini, and reverting the commit
> also allows the driver to seemingly resume correctly. 

Still it stands: 

Your sky2 patch #44ade178249fe53d055fd92113eaa271e06acddd is broken.

Just get it.

	tglx


