Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbZBQC60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbZBQC60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 21:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZBQC6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 21:58:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:51643 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbZBQC6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 21:58:17 -0500
Date: Mon, 16 Feb 2009 18:57:58 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090216185758.1a4d041d@infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.0902162141190.24097-100000@netrider.rowland.org>
References: <20090216145655.727cd39c@infradead.org>
	<Pine.LNX.4.44L0.0902162141190.24097-100000@netrider.rowland.org>
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

On Mon, 16 Feb 2009 21:43:52 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Mon, 16 Feb 2009, Arjan van de Ven wrote:
> 
> > > Set the automatic PM parameters (idle timeout, state to go to,
> > > etc.). And disabling automatic PM altogether (effectively the
> > > same as setting the idle timeout to infinity).
> > > 
> > 
> > shouldn't idle timeout etc be internal to the driver?
> > Yes policy preferences / constraints makes sense to communicate,
> > actual settings do not. For one they keep changing fast all the time
> > anyway.
> 
> Sorry, I don't agree.  A single driver may control many different
> kinds of device -- it may not even be aware of the distinction!
> Consider the SCSI disk driver: It has to handle both traditional
> rotating media and solid-state disks.  Clearly they should have
> different runtime PM parameters.  But the driver isn't in a good
> position to know what those parameters should be.

... and userspace is ?
Sorry I don't buy that. Kernel is supposed to abstract the hardware...
That's its fundamental task. Now if the driver doesn't know it can get
help from the subsystem, that's perfectly fine.


(and quiet often the kernel gets updated more often as the userspace)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
