Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbZBRQvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbZBRQvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbZBRQvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:51:31 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56691 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752941AbZBRQva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:51:30 -0500
Date: Wed, 18 Feb 2009 11:51:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Laurent Riffard <laurent.riffard@free.fr>, <linux-input@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: linux-next: USB mouse won't work after resume.
In-Reply-To: <200902172142.57302.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0902181150370.17341-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009, Oliver Neukum wrote:

> Am Tuesday 17 February 2009 14:37:04 schrieb Laurent Riffard:
> > Le 17.02.2009 11:35, Oliver Neukum a écrit :
> > > Am Tuesday 17 February 2009 10:55:57 schrieb Laurent Riffard:
> > >> My USB mouse won't work after suspend to disk and resume. I must unload and reload the ohci_hcd module to get it back.
> > > 
> > > Please recompile your kernel with CONFIG_USB_DEBUG and
> > > send me your dmesg.
> > > 
> > > 	Regards
> > > 		Oliver
> > > 
> > 
> > Here is it:
> > 
> 
> Please try the attached patch.

By the way, have you tested to see if the post_reset method needs an 
equivalent change?

Alan Stern

