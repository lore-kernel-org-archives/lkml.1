Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYH1RWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYH1RWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYH1RWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:22:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40198 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752786AbYH1RWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:22:39 -0400
Date: Thu, 28 Aug 2008 13:22:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linuxppc-dev@ozlabs.org, Li Yang <leoli@freescale.com>, <greg@kroah.com>,
       <linux-usb@vger.kernel.org>, <dbrownell@users.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller
 driver
In-Reply-To: <200808281704.20999.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.0808281320010.2464-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, Arnd Bergmann wrote:

> Not addressing this driver in particular, but the USB gadget layer in
> general: This is a horrible interface, since every gadget driver exports
> the same symbols, you can never build a kernel that includes more than
> one gadget driver. Even if the drivers are all built as modules, simply
> loading one of them prevents loading another one.

This was done deliberately.  The relevant standards state that a USB
device can have no more than one peripheral interface.

Now, I don't claim to fully support this decision.  But there is a 
reason behind it; it's not just a case of bad design.

Alan Stern

