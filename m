Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbXKAV0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbXKAV0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 17:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXKAV00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:26:26 -0400
Received: from THUNK.ORG ([69.25.196.29]:44560 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbXKAV0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:26:24 -0400
Date: Thu, 1 Nov 2007 17:25:38 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bongani Hlope <bonganilinux@mweb.co.za>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: irq 21: nobody cared 2.6.24-rc1
Message-ID: <20071101212538.GH2387@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bongani Hlope <bonganilinux@mweb.co.za>,
	linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
References: <200710251045.37040.bonganilinux@mweb.co.za> <20071101133238.16bb9a3f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101133238.16bb9a3f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 01:32:38PM -0700, Andrew Morton wrote:
> On Thu, 25 Oct 2007 10:45:36 +0200
> Bongani Hlope <bonganilinux@mweb.co.za> wrote:
> 
> > Booting with irqpoll works
> > 
> > ls /proc/irq/21/ (with irqpoll)
> > ehci_hcd:usb1/  smp_affinity  uhci_hcd:usb2/  uhci_hcd:usb3/  uhci_hcd:usb4/
> > 
> > irq 21: nobody cared (try booting with the "irqpoll" option)
>
> 
> Was any earlier kernel version OK?  2.6.23?

I've started seeing this too, sometime at or after 2.6.24-rc1.  2.6.23
was OK.  In fact 2.6.23-git14 or so was fine...  There have been
enough other regressions though that I haven't had time to bisect this
one.

							- Ted
