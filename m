Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbYFVTbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbYFVTbk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbYFVTbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:31:31 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3933 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753291AbYFVTba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:31:30 -0400
Date: Sun, 22 Jun 2008 15:31:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Rene Herman <rene.herman@keyaccess.nl>
cc: Stefan Becker <Stefan.Becker@nokia.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: [REGRESSION] 2.6.24/25: random lockups when accessing external
 USB harddrive
In-Reply-To: <485E8F05.3020406@keyaccess.nl>
Message-ID: <Pine.LNX.4.44L0.0806221521330.21150-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008, Rene Herman wrote:

> On 22-06-08 18:55, Stefan Becker wrote:
> 
> Only adding Alan Stern to the CC...
> 
> > Hi,
> > 
> > [I'm not subscribed to this list, so please CC: me when you answer]
> > 
> > I get random machine lockups when accessing my USB harddrive with 
> > kernels 2.6.24/25. They don't occur with kernel 2.6.23. During testing I 
> > figured out that it has something to do with the USB Bluetooth adaptor. 
> > If I remove it before the testing I don't get any lockups.

Does the same problem still occur in 2.6.26-rc7?  Does it occur if you 
rmmod ehci-hcd?

Machine lockups are awfully hard to debug.  Can you get any information
at all (like Alt-SysRq-T) when this happens?  Can you add debugging
printk statements to the USB bluetooth driver to try and localize where
the hang occurs?

> > git bisect resulted in the following bad commit:
> > 
> > e9df41c5c5899259541dc928872cad4d07b82076 is first bad commit
> > commit e9df41c5c5899259541dc928872cad4d07b82076
> > Author: Alan Stern <stern@rowland.harvard.edu>
> > Date:   Wed Aug 8 11:48:02 2007 -0400
> > 
> >     USB: make HCDs responsible for managing endpoint queues

Knowing this doesn't help much without more information.

Do you have any idea why nobody else has reported this sort of problem?  
Is it reproducible on other machines?

Alan Stern

