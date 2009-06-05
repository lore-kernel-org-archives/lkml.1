Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbZFEPI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbZFEPI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbZFEPIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:08:30 -0400
Received: from netrider.rowland.org ([192.131.102.5]:49348 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754216AbZFEPI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:08:28 -0400
Date: Fri, 5 Jun 2009 11:08:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Peter Chubb <peterc@gelato.unsw.edu.au>
cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Oops with minicom and USB serial with Linux 2.6.30-rc8
In-Reply-To: <87prdj5nz7.wl%peter@chubb.wattle.id.au>
Message-ID: <Pine.LNX.4.44L0.0906051104130.10297-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009, Peter Chubb wrote:

> I rebuilt with frame pointers and debug symbols.
> I see lots and lots of:
> 
> ....
> usb 2-2: clear tt 1 (1042) error -71
> usb 2-2: clear tt 1 (1042) error -71
> usb 2-2: clear tt 1 (1042) error -71
> usb 2-2: clear tt 1 (1042) error -71
> usb 2-2: clear tt 1 (1042) error -71
> usb 2-2: clear tt 1 (1042) error -71
> usb 2-2.3: USB disconnect, address 14
> 
> Investigations continue...  usb 2-2 is the hub to which the PL2303
> is attached.
> 
> I now see a similar traceback to before, not when I press the reset
> button, but when I remove the USB connector.

A couple of relevant patches were posted recently:

	http://marc.info/?l=linux-usb&m=124395806322087&w=2
	http://marc.info/?l=linux-usb&m=124395806222085&w=2

The second is more revelant than the first, but it might not apply 
without the first one.

Alan Stern

