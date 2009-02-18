Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZBRPWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZBRPWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZBRPW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:22:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54057 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbZBRPWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:22:25 -0500
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Matthew Garrett <mjg@redhat.com>, Arjan van de Ven <arjan@infradead.org>
CC: Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>, Len Brown <lenb@kernel.org>
Date: Wed, 18 Feb 2009 09:20:02 -0600
Subject: RE: [RFD] Automatic suspend
Thread-Topic: [RFD] Automatic suspend
Thread-Index: AcmR2858FrUC400sTZG94blC0iVAHQAAESsw
Message-ID: <13B9B4C6EF24D648824FF11BE896716203772616FE@dlee02.ent.ti.com>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
 <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com>
 <20090216145948.6fea81c3@infradead.org> <200902170019.40599.rjw@sisk.pl>
 <20090216232329.GA15678@srcf.ucam.org>
 <20090217142001.GB12378@bulgaria.corp.google.com>
 <20090217064630.688bf639@infradead.org>
 <20090217145141.GA26158@srcf.ucam.org>
 <20090217065622.3e0a9956@infradead.org>
 <20090218151529.GB15195@srcf.ucam.org>
In-Reply-To: <20090218151529.GB15195@srcf.ucam.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > so use range timers / timer slack for those apps that you do not trust.
> > That is not a big deal, and solves the issue of timer wakeups...
>
> So have userspace say something like "The screen is turned off now,
> change the timer precision on all untrusted userland to sub 10 seconds"?
> That would work.

I also made a similar comment in thread to Arjan yesterday.

He did respond saying there was a pctrl to hit this.  If it's a big list it might be messy.  Unless it can be global.  Probably would be good to look at code rather than speculate.

