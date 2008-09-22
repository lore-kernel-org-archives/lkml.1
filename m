Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbYIVKx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbYIVKx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYIVKxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:53:47 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2723 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752001AbYIVKxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:53:46 -0400
Date: Mon, 22 Sep 2008 06:53:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Justin Mattock <justinmattock@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [Bug #11552] Disabling IRQ #23
In-Reply-To: <dd18b0c30809211616g658b50c8k2ea9f9953f1de96f@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0809220651080.13379-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Sep 2008, Justin Mattock wrote:

> From over here, I did a bad install
> of isight-firmware-tools, causing hal and udev
> to clash.  After making sure the package was either
> using hal or udev, there is no message of disable irq #23.
> If its not too much trouble is there a way to verify that this was
> the case, i.g. if udev creates a dev, then hal creates the same device
> will this cause ehci_hcd to have messages of this kind? If so
> then thats what happened, if not then theres something else causing this.

You didn't read what I wrote earlier, did you?  The "HC died" message 
should NEVER occur!  It doesn't matter what games you play with hal and 
udev -- it should NEVER occur.  Not ever.

And since the "HC died" is what causes IRQ #23 to be disabled, that 
shouldn't happen either.

Alan Stern

