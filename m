Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbZBPU3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbZBPU3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZBPU2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:28:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:40792 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbZBPU2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:28:53 -0500
Date: Mon, 16 Feb 2009 12:28:30 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090216122830.4096c5b0@infradead.org>
In-Reply-To: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
References: <200902160010.16955.rjw@sisk.pl>
	<200902160806.17901.oliver@neukum.org>
	<20090216074048.6d70f17c@infradead.org>
	<200902161748.09208.oliver@neukum.org>
	<20090216093108.078aac35@infradead.org>
	<f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
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

On Mon, 16 Feb 2009 15:08:09 -0500
Kyle Moffett <kyle@moffetthome.net> wrote:

> I think it would be very useful to have a mechanism for userspace to
> find out "Link detection on this NIC costs ~50mW" and "No link has
> been detected for the last 15 minutes", so that it can compile all
> that sort of information and prompt the user what devices they would
> like to disable.  Perhaps an "airline mode" sort of thing

modes suck... they're very much the wrong concept for power management
(but that's a different story)

if the user (or something on its behalf) doesn't need link detection,
he can turn it off. Really. He doesn't need to know that maybe on
machine one this saves some power, and on machine two that power was
already mostly saved while on machine three it doesn't save anything at
all. Not to mention that the driver is extremely unlikely to know how
much actual power will be saved...
 



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
