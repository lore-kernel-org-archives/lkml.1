Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbXHTIg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbXHTIg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 04:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbXHTIgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 04:36:39 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:44822 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbXHTIgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 04:36:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=UWEymQ+XCXw+KlE3DGfQwsYiro84zO4DPd1UXjkD8QJLnv/ZtnTY7Wc0+rIQ22pSWlYf0D+m/jzBXwWSyjewe2Ba6B356wFhp+e/DeCfAQOr1DQsy9BMfmynQiA8Wc8YxuqaL7xU9hp7sljpGvJ4HuXnrDSItwOdFZ2tROP1h+8=
Date: Mon, 20 Aug 2007 12:35:59 +0400
From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-hrt2 stall during boot on ASUS F3T (x86_64)
Message-ID: <20070820123559.3582f3bc@localhost>
In-Reply-To: <1187596481.7007.169.camel@chaos>
References: <20070820104455.0dc7fe3d@localhost>
	<1187592717.6114.170.camel@twins>
	<1187596481.7007.169.camel@chaos>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007 09:54:41 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 2007-08-20 at 08:51 +0200, Peter Zijlstra wrote:
> > On Mon, 2007-08-20 at 10:44 +0400, Mikhail Kshevetskiy wrote:
> > > There are at list two serious delays:
> > > 
> > >   at 73.442744: I do nothing, the kernel continue to boot after 168 sec
> > > 
> > >   at 243.497822: After 2 hours i press and hold "shift" button to continue booting 
> > > 
> > > The dmesg output and my kernel configuration are listed below. 
> > > 
> > > I test i386 version of the same kernel with very similar configuration, it boot normally.
> 
> Can you please add "noapictimer" to the kernel command line ?
> 
> 	tglx
> 
> 

This helps, thank you.
Why it is not required for i386 kernel?
Is it possible to fix this problem without disabling of apic timer?

Mikhail Kshevetskiy

