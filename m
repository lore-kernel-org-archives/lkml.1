Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbYHJPqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbYHJPqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbYHJPoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:44:06 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3588 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757547AbYHJPoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:44:04 -0400
Date: Sun, 10 Aug 2008 11:44:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Diego Zuccato <diego@otello.alma.unibo.it>
cc: Frans Pop <elendil@planet.nl>, <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: [regression?] usb: new errors during device detection
In-Reply-To: <489D9B46.60001@otello.alma.unibo.it>
Message-ID: <Pine.LNX.4.44L0.0808101143100.942-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Aug 2008, Diego Zuccato wrote:

> Alan Stern ha scritto:
> 
> > As each device is enumerated, ehci-hcd determines whether it can run at 
> > high speed.  If not, the corresponding switch is set so the device 
> > connects back to the UHCI controller and it runs at full/low speed.
> Urgh... What happens if it contains a mounted filesystem?
> Seems quite dangerous...

It's no more dangerous than somebody unplugging the USB cable by 
mistake.  :-)

Alan Stern

