Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbZBQPMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbZBQPMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbZBQPMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:12:06 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49069 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752967AbZBQPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:12:04 -0500
Date: Tue, 17 Feb 2009 10:12:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Laurent Riffard <laurent.riffard@free.fr>
cc: Oliver Neukum <oliver@neukum.org>, <linux-input@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: linux-next: USB mouse won't work after resume.
In-Reply-To: <499ABD80.9020904@free.fr>
Message-ID: <Pine.LNX.4.44L0.0902171011240.3195-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009, Laurent Riffard wrote:

> Le 17.02.2009 11:35, Oliver Neukum a écrit :
> > Am Tuesday 17 February 2009 10:55:57 schrieb Laurent Riffard:
> >> My USB mouse won't work after suspend to disk and resume. I must unload and reload the ohci_hcd module to get it back.
> > 
> > Please recompile your kernel with CONFIG_USB_DEBUG and
> > send me your dmesg.
> > 
> > 	Regards
> > 		Oliver
> > 
> 
> Here is it:

Maybe there's a bug in the way the HID autosuspend patch cooperates 
with reset-resume.

Alan Stern

