Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbZBPT6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbZBPT6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 14:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZBPT61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 14:58:27 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1712 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751591AbZBPT61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 14:58:27 -0500
Date: Mon, 16 Feb 2009 14:58:23 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       <mm-commits@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       USB list <linux-usb@vger.kernel.org>, <linux-input@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: dead USB devices after resume [mmotm 2009-02-10-16-35]
In-Reply-To: <49996F43.2070801@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0902161448500.18928-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009, Jiri Slaby wrote:

> Alan Stern wrote:
> > So the problem must be lower down, such as in the usbhid driver.  The 
> > best way to track this is to use usbmon.
> 
> Well, there is some traffic after resume, but nothing when pressing keys...

Unforunately the most important part of the log was lost, probably
because the usbmon buffer filled up.  (It's the part between the
2320601617 and 2376096580 timestamps -- a 56-second gap.)  You can try
again after increasing the value of EVENT_MAX in
drivers/usb/mon/mon_text.c.

Alan Stern


