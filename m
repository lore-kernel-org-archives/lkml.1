Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbZBQO4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbZBQO4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZBQO4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:56:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:52360 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbZBQO4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:56:30 -0500
Date: Tue, 17 Feb 2009 06:56:22 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090217065622.3e0a9956@infradead.org>
In-Reply-To: <20090217145141.GA26158@srcf.ucam.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
	<13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com>
	<20090216145948.6fea81c3@infradead.org>
	<200902170019.40599.rjw@sisk.pl>
	<20090216232329.GA15678@srcf.ucam.org>
	<20090217142001.GB12378@bulgaria.corp.google.com>
	<20090217064630.688bf639@infradead.org>
	<20090217145141.GA26158@srcf.ucam.org>
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

On Tue, 17 Feb 2009 14:51:41 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Tue, Feb 17, 2009 at 06:46:30AM -0800, Arjan van de Ven wrote:
> 
> > actually with powertop... on the open source side things are
> > actually won. It took all of 6 months...
> > I don't see that as a valid excuse. In fact, if this kind of
> > solution makes real userspace scheduled timers to be missed then I
> > consider it a serious functionality misfeature.
> 
> Remember that Android has an open marketplace designed to appeal to
> Java programmers - users are going to end up downloading code from
> there and then blaming the platform if their battery life heads
> towards zero. I think "We can't trust our userland not to be dumb" is
> a valid concern.

so use range timers / timer slack for those apps that you do not trust.
That is not a big deal, and solves the issue of timer wakeups...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
