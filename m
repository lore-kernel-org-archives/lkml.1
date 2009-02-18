Return-Path: <linux-kernel-owner+w=401wt.eu-S1758931AbZBRWGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbZBRWGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627AbZBRWGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:06:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:58970 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439AbZBRWGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:06:24 -0500
Subject: Re: [RFD] Automatic suspend
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Brian Swetland <swetland@google.com>,
       Arjan van de Ven <arjan@infradead.org>,
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
In-Reply-To: <20090218175244.GA19235@srcf.ucam.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
	 <20090217152811.GA12686@bulgaria.corp.google.com>
	 <1234924840.14060.342.camel@pasglop>
	 <200902180948.06039.jbarnes@virtuousgeek.org>
	 <20090218175244.GA19235@srcf.ucam.org>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 09:05:07 +1100
Message-Id: <1234994707.14060.466.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 17:52 +0000, Matthew Garrett wrote:
> On Wed, Feb 18, 2009 at 09:48:04AM -0800, Jesse Barnes wrote:
> 
> > I think "powernag" would be a better name, and it would probably work pretty 
> > well.  Users would be notified that certain apps should probably be shut down 
> > while they're on battery, and nag the authors to fix it.
> 
> How do you usefully tell the difference between an application that's 
> waking up a lot because it's dumb and an application that's waking up a 
> lot because it's doing something useful? One downside of powertop is 
> that it's resulted in a lot of "How do I reduce the number of wakeups 
> caused by i8042 whenever I use the mouse"-type questions. We don't want 
> innocent app writers to be hit by this kind of thing.

Which is why nagging might not be the best thing... One thing I quite
liked was something i had on MacOS 9 which was a watt-meter. I could
basically see at any time what my consumption was. If the needle wasn't
all the way to the left while I was expecting it to, I would dig for
the culprit.

Maybe we can try to do something similar, and when clicking on it,
you get an ordered list of apps from the biggest consumer down).

The main problem of course is for that "meter" to work, one need to have
an idea of what min and max are on a given machine... Absolute watt
numbers or things like that are a lot less telling to Joe average.

Cheers,
Ben.

