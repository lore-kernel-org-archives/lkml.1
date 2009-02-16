Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZBPUj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZBPUj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZBPUjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:39:20 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1749 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751104AbZBPUjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:39:20 -0500
Date: Mon, 16 Feb 2009 15:39:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kyle Moffett <kyle@moffetthome.net>
cc: Arjan van de Ven <arjan@infradead.org>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
In-Reply-To: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0902161537080.19732-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009, Kyle Moffett wrote:

> Userspace may not have a useful decision-making capability regarding
> functionality versus power-saving, but the user it's talking to might!
> 
> I think it would be very useful to have a mechanism for userspace to
> find out "Link detection on this NIC costs ~50mW" and "No link has
> been detected for the last 15 minutes", so that it can compile all
> that sort of information and prompt the user what devices they would
> like to disable.  Perhaps an "airline mode" sort of thing?

Even if drivers don't know how much power their devices consume (and
generally I wouldn't expect them to), it still makes sense to offer
userspace the discretionary power to force devices into a low-power
mode.  USB does this.

Alan Stern

