Return-Path: <linux-kernel-owner+w=401wt.eu-S1761891AbYBGW7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761891AbYBGW7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756334AbYBGW70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:59:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40416 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716AbYBGW7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:59:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Date: Thu, 7 Feb 2008 23:57:32 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
References: <20080205190600.GB11613@elf.ucw.cz> <20080207222845.GA6096@elf.ucw.cz> <47AB8A41.3040008@zytor.com>
In-Reply-To: <47AB8A41.3040008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802072357.33293.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 7 of February 2008, H. Peter Anvin wrote:
> Pavel Machek wrote:
> > 
> > This is probably more acceptable version of beep; but there are
> > probably even better ways to clean it...
> > 
> >         if (wakeup_header.realmode_flags & 4) {
> >                 inb(97);
> >                 outb(0, 0x80);
> >                 outb(3, 97);
> >                 outb(0, 0x80);
> >                 outb(-74, 67);
> >                 outb(0, 0x80);
> >                 outb(-119, 66);
> >                 outb(0, 0x80);
> >                 outb(15, 66);
> >         }
> > 
> 
> What is available at this point -- are BIOS calls still accessible; are 
> interrupts running?

No interrupts.

We're in the real mode, so BIOS calls should be accessible.

Rafael
