Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZBPXlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZBPXlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZBPXlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:41:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:43124 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZBPXlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:41:40 -0500
Date: Mon, 16 Feb 2009 15:41:30 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090216154130.3ecf4050@infradead.org>
In-Reply-To: <200902170019.40599.rjw@sisk.pl>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
	<13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com>
	<20090216145948.6fea81c3@infradead.org>
	<200902170019.40599.rjw@sisk.pl>
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

On Tue, 17 Feb 2009 00:19:38 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > In addition, in hardware there does seem to be the trend where idle
> > and suspend are converging (just look at the OLPC)...   with
> > chipsets powering down all unused pieces, and cpus in idle taking
> > basically no power, there no longer is much of a difference in
> > reality between suspend and good-idle...
> 
> This, again, seems to be a bit x86-centric. :-)  

actually absolutely not. To the contrary. It is, as you said, the
embedded systems that have, and increasingly get, finer grained per
device controls. (x86 embedded and otherwise). The more fine grained
control you have, the less a system wide state will give you in
additional power savings. This is pretty much the industry trend for
all power sensitive systems.

Android might be using last years hardware. I'm not saying we shouldn't
support that, but we need to be careful to not design the system only
looking backwards.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
