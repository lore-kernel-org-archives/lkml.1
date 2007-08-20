Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbXHTHyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbXHTHyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 03:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbXHTHyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 03:54:45 -0400
Received: from www.osadl.org ([213.239.205.134]:55252 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750926AbXHTHyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 03:54:45 -0400
Subject: Re: 2.6.23-rc3-hrt2 stall during boot on ASUS F3T (x86_64)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1187592717.6114.170.camel@twins>
References: <20070820104455.0dc7fe3d@localhost>
	 <1187592717.6114.170.camel@twins>
Content-Type: text/plain
Date: Mon, 20 Aug 2007 09:54:41 +0200
Message-Id: <1187596481.7007.169.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 08:51 +0200, Peter Zijlstra wrote:
> On Mon, 2007-08-20 at 10:44 +0400, Mikhail Kshevetskiy wrote:
> > There are at list two serious delays:
> > 
> >   at 73.442744: I do nothing, the kernel continue to boot after 168 sec
> > 
> >   at 243.497822: After 2 hours i press and hold "shift" button to continue booting 
> > 
> > The dmesg output and my kernel configuration are listed below. 
> > 
> > I test i386 version of the same kernel with very similar configuration, it boot normally.

Can you please add "noapictimer" to the kernel command line ?

	tglx


