Return-Path: <linux-kernel-owner+w=401wt.eu-S965086AbZLGVqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965086AbZLGVqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 16:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965068AbZLGVqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 16:46:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43853 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965055AbZLGVqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 16:46:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Date: Mon, 7 Dec 2009 22:47:02 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912071610520.15701-100000@iolanthe.rowland.org> <alpine.LFD.2.00.0912071337020.3560@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912071337020.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912072247.02318.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 December 2009, Linus Torvalds wrote:
> 
> On Mon, 7 Dec 2009, Alan Stern wrote:
> > 
> > It only seems that way because you didn't take into account devices 
> > that suspend synchronously but whose children suspend asynchronously.
> 
> But why would I care? If somebody suspends synchronously, then that's what 
> he wants.
> 
> > A synchronous suspend routine for a device with async child suspends
> > would have to look just like your usb_node_suspend():
> 
> Sure. But that sounds like a "Doctor, it hurts when I do this" situation. 
> Don't do that.
> 
> Make the USB host controller do its suspend asynchronously. We don't 
> suspend PCI bridges anyway, iirc (but I didn't actually check).

That's correct, we don't.

Rafael
