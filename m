Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZBPUqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZBPUqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbZBPUpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:45:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:46551 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZBPUpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:45:54 -0500
Date: Mon, 16 Feb 2009 12:45:20 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090216124520.315320dc@infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.0902161537080.19732-100000@netrider.rowland.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
	<Pine.LNX.4.44L0.0902161537080.19732-100000@netrider.rowland.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 15:39:15 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Mon, 16 Feb 2009, Kyle Moffett wrote:
> 
> > Userspace may not have a useful decision-making capability regarding
> > functionality versus power-saving, but the user it's talking to
> > might!
> > 
> > I think it would be very useful to have a mechanism for userspace to
> > find out "Link detection on this NIC costs ~50mW" and "No link has
> > been detected for the last 15 minutes", so that it can compile all
> > that sort of information and prompt the user what devices they would
> > like to disable.  Perhaps an "airline mode" sort of thing?
> 
> Even if drivers don't know how much power their devices consume (and
> generally I wouldn't expect them to), it still makes sense to offer
> userspace the discretionary power to force devices into a low-power
> mode.  USB does this.

"stop using it" isn't this discretionary power ?
(for NICs this is "ifconfig .. down")

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
