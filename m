Return-Path: <linux-kernel-owner+w=401wt.eu-S1758480AbZBTP23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480AbZBTP23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZBTP2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:28:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:35768 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbZBTP2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:28:18 -0500
Date: Fri, 20 Feb 2009 07:27:46 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090220072746.7d7a27cd@infradead.org>
In-Reply-To: <d6200be20902192135y166eb90bt895c97c7b381c44c@mail.gmail.com>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
	<13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com>
	<20090216145948.6fea81c3@infradead.org>
	<200902170019.40599.rjw@sisk.pl>
	<20090216232329.GA15678@srcf.ucam.org>
	<d6200be20902192135y166eb90bt895c97c7b381c44c@mail.gmail.com>
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

On Thu, 19 Feb 2009 21:35:39 -0800
Arve Hjønnevåg <arve@android.com> wrote:

> However, if you
> install an application that wakes up 60 times a second (to check if it
> need to draw something on the screen) the difference between idle and
> suspend becomes 10 hours versus 40 days, or 10 hours versus 3 days
> with my use.

then that is the point where you use the timerslack to throttle such
non-system applications.... that's very obvious and there today..


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
