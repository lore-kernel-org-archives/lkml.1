Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbZBPW5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbZBPW5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZBPW4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:56:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:37619 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZBPW4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:56:53 -0500
Date: Mon, 16 Feb 2009 14:56:55 -0800
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
Message-ID: <20090216145655.727cd39c@infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.0902161736210.21117-100000@netrider.rowland.org>
References: <200902162312.50556.rjw@sisk.pl>
	<Pine.LNX.4.44L0.0902161736210.21117-100000@netrider.rowland.org>
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

On Mon, 16 Feb 2009 17:40:10 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Mon, 16 Feb 2009, Rafael J. Wysocki wrote:
> 
> > OK, so I think there are two things that user space may be allowed
> > to do as far as putting devices into low power states is concerned:
> > * disable/enable the automatic power management of the device
> > (provided that the driver supports the automatic PM)
> 
> Set the automatic PM parameters (idle timeout, state to go to,
> etc.). And disabling automatic PM altogether (effectively the same as
> setting the idle timeout to infinity).
> 

shouldn't idle timeout etc be internal to the driver?
Yes policy preferences / constraints makes sense to communicate,
actual settings do not. For one they keep changing fast all the time
anyway.
 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
