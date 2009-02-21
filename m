Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZBUJwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZBUJwi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 04:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZBUJwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 04:52:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59128 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbZBUJwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 04:52:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFD] Automatic suspend
Date: Sat, 21 Feb 2009 10:52:09 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902192215.18365.rjw@sisk.pl> <200902210040.50344.rjw@sisk.pl> <20090220234548.GA9297@srcf.ucam.org>
In-Reply-To: <20090220234548.GA9297@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902211052.10989.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 February 2009, Matthew Garrett wrote:
> On Sat, Feb 21, 2009 at 12:40:48AM +0100, Rafael J. Wysocki wrote:
> 
> > We can't do the quirks from the kernel and that's one of the reasons why I
> > think user space should start automatic suspend (it can do the quirks if
> > necessary).
> 
> Any sort of automatic suspend is simply impossible in a world where your 
> drivers don't work properly. There's code for making intel and radeon 
> handle suspend/resume themselves now, and nvidia before g80 should also 
> be easy. More recent nvidia is going to be some work.
> 
> But yeah. Let's not have "Work around broken drivers" as a design goal. 

OK, I'm withdrawing it, then. :-)

> The argument against timeouts in wakelocks works just as well here.

So, what do you thing about the approach desribed earlier in this thread
(http://lkml.org/lkml/2009/2/20/182)?

Rafael
