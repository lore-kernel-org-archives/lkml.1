Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbXGDOoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbXGDOoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 10:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760630AbXGDOoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 10:44:23 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4059 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758422AbXGDOoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 10:44:23 -0400
Date: Wed, 4 Jul 2007 10:44:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Paul Mackerras <paulus@samba.org>
cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <18058.55215.185633.434117@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0707041042590.25704-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007, Paul Mackerras wrote:

> Oliver Neukum writes:
> 
> > USB devices certainly have suspend methods.
> 
> Indeed, and the USB framework has code to know when the host
> controller is suspended and avoid trying to send out urbs in that
> case.  Or at least it did last time I looked at it in any detail; it's
> been "just working" - including suspending and resuming, without the
> freezer - for quite a while now.

Evidently you haven't been stressing it.  You might try suspending
while printing to a USB printer.

Alan Stern

