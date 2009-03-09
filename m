Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbZCIOxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbZCIOxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 10:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZCIOxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 10:53:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41319 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751422AbZCIOxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 10:53:35 -0400
Date: Mon, 9 Mar 2009 10:53:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Loading both ehci-hcd and uhci-hcd drivers causes my
 printer to fail
In-Reply-To: <1236601606.7762.15.camel@maxim-laptop>
Message-ID: <Pine.LNX.4.44L0.0903091050280.3778-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, Maxim Levitsky wrote:

> Sorry, sorry, sorry.
> 
> is was the CONFIG_USB_EHCI_TT_NEWSCHED that did it.
> I confused both options, without the above option printer works
> flawlessly.

Is your printer connected directly to the computer, or does it go 
through a hub?  (If it is connected directly then EHCI_TT_NEWSCHED 
should not affect it at all.)

If it does go through a hub, does it behave better when you attach it 
directly?

Alan Stern

