Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZBRCni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZBRCni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 21:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZBRCn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 21:43:29 -0500
Received: from gate.crashing.org ([63.228.1.57]:40319 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZBRCn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 21:43:28 -0500
Subject: Re: [RFD] Automatic suspend
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Brian Swetland <swetland@google.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>, Len Brown <lenb@kernel.org>
In-Reply-To: <20090217152811.GA12686@bulgaria.corp.google.com>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
	 <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com>
	 <20090216145948.6fea81c3@infradead.org> <200902170019.40599.rjw@sisk.pl>
	 <20090216232329.GA15678@srcf.ucam.org>
	 <20090217142001.GB12378@bulgaria.corp.google.com>
	 <20090217064630.688bf639@infradead.org>
	 <20090217152811.GA12686@bulgaria.corp.google.com>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 13:40:40 +1100
Message-Id: <1234924840.14060.342.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> You will end up with some crappy apps that do really dumb things.
> However, even if they're badly written users may still install and use
> these apps because hey, they do something the user likes.
> 
> >From the Android standpoint, we're trying to balance protecting the
> system from poorly designed apps and somehow letting the user know "hey
> app X is chewing up a lot of power" (work in progress on this).
> 
> While I'd love for every app developer to actively tune their apps for a
> good mobile experience, I am skeptical that this is going to happen.

One idea I've been toying around was to have powertune as some kind of
background thingy, and have it pop an icon in the notification area when
some app seems to behave badly (of course, defining "badly" is hard but
heh...). IE. actively inform the user "this application is sucking the
life out of your battery".

Cheers,
Ben.


