Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZBRFzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZBRFzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 00:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZBRFzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 00:55:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:59396 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbZBRFzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 00:55:42 -0500
Date: Tue, 17 Feb 2009 21:55:32 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: "Woodruff, Richard" <r-woodruff2@ti.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>, Len Brown <lenb@kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090217215532.5ae533a6@infradead.org>
In-Reply-To: <d6200be20902172111y16debabaq85b8f58520f4079a@mail.gmail.com>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
	<20090216145948.6fea81c3@infradead.org>
	<200902170019.40599.rjw@sisk.pl>
	<20090216232329.GA15678@srcf.ucam.org>
	<20090217142001.GB12378@bulgaria.corp.google.com>
	<20090217064630.688bf639@infradead.org>
	<20090217145141.GA26158@srcf.ucam.org>
	<20090217065622.3e0a9956@infradead.org>
	<13B9B4C6EF24D648824FF11BE896716203771DD342@dlee02.ent.ti.com>
	<20090217160421.12bc851f@infradead.org>
	<d6200be20902172111y16debabaq85b8f58520f4079a@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009 21:11:31 -0800
Arve Hjønnevåg <arve@android.com> wrote:

> On Tue, Feb 17, 2009 at 4:04 PM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > On Tue, 17 Feb 2009 09:32:46 -0600
> > "Woodruff, Richard" <r-woodruff2@ti.com> wrote:
> >
> >> > so use range timers / timer slack for those apps that you do not
> >> > trust. That is not a big deal, and solves the issue of timer
> >> > wakeups...
> >>
> >> I not so sure it is that straight forward in practice.  End systems
> >> integrate a lot of 3rd party software who view performance 1st and
> >> have no thought of power.
> >
> > you know that with the range timers/slack, you can control the
> > "rounding" of the timer of the application, right?
> > You can *directly* throttle the number of wakeups an application
> > causes that way to a value you set.
> 
> I thought the point of range timers was to align multiple timers so
> they wakeup at the same time, not to throttle individual timers.

it works both ways.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
