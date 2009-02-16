Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbZBPVwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbZBPVwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZBPVwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:52:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:53341 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbZBPVwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:52:14 -0500
Date: Mon, 16 Feb 2009 13:52:04 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Woodruff, Richard" <r-woodruff2@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
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
Message-ID: <20090216135204.064f553b@infradead.org>
In-Reply-To: <13B9B4C6EF24D648824FF11BE896716203771DCF1E@dlee02.ent.ti.com>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
	<Pine.LNX.4.44L0.0902161537080.19732-100000@netrider.rowland.org>
	<20090216124520.315320dc@infradead.org>
	<13B9B4C6EF24D648824FF11BE896716203771DCF1E@dlee02.ent.ti.com>
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

On Mon, 16 Feb 2009 15:32:06 -0600
"Woodruff, Richard" <r-woodruff2@ti.com> wrote:
> 
> - It provides a way to handle overdrive/turbo operating points out of
> band from the generically tuned cpufreq governors like ondemand.  The
> way we characterize overdrive is stricter then what Intel has talked
> about for x86.

if you have an improved-for-your-systems governor then I'm sure that is
very welcome in the kernel.

I agree that perfect is the enemy of good.

I think just about all of us agree that the final decision needs to be
in the driver (possibly followed by something that gets various device
requests and combines it into hw settings); we're just talking about
what inputs feed into that decision ;)

And for different types of devices that's guaranteed to be different...
and sometimes we'll be hampered by existing interfaces, so we might end
up with hacky stuff.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
