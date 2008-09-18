Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbYIRWXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbYIRWXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 18:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755663AbYIRWXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 18:23:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49407 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755527AbYIRWXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 18:23:05 -0400
Date: Thu, 18 Sep 2008 18:23:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Mattock <justinmattock@gmail.com>
cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Chris Snook <csnook@redhat.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [19.666764] Disabling IRQ #23
In-Reply-To: <dd18b0c30809172144s75bf684am951159218717972e@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0809181818200.17483-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008, Justin Mattock wrote:

> Hello,
> after a bit of
> searching I located a patch for something
> that might be similar to this issue:(cant seem to locate the
> linux-kernel thread).
> http://www.gossamer-threads.com/lists/linux/kernel/966076
> I've applied the patches just to see what would happen,
> As for now I have not seen the Disable irq #23 yet,
> (usually after a recompile of the kernel, upon reboot this message will appear,
> this time it didn't). But you never know I'll run the system for a few days
> and see if it pops up.

You are concentrating on the symptom instead of the problem.  The
symptom is that "Disabling IRQ #23" message -- don't worry about it.  

The underlying problem is the "ehci_hcd 0000:00:1d.7: HC died;
cleaning up" message -- it should _never_ appear.  If you have a 
reliable way of provoking it then something needs to be fixed.

Alan Stern

