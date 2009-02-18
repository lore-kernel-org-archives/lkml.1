Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbZBRRxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbZBRRxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZBRRxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:53:07 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40680 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbZBRRxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:53:06 -0500
Date: Wed, 18 Feb 2009 17:52:44 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Brian Swetland <swetland@google.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090218175244.GA19235@srcf.ucam.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <20090217152811.GA12686@bulgaria.corp.google.com> <1234924840.14060.342.camel@pasglop> <200902180948.06039.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902180948.06039.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 09:48:04AM -0800, Jesse Barnes wrote:

> I think "powernag" would be a better name, and it would probably work pretty 
> well.  Users would be notified that certain apps should probably be shut down 
> while they're on battery, and nag the authors to fix it.

How do you usefully tell the difference between an application that's 
waking up a lot because it's dumb and an application that's waking up a 
lot because it's doing something useful? One downside of powertop is 
that it's resulted in a lot of "How do I reduce the number of wakeups 
caused by i8042 whenever I use the mouse"-type questions. We don't want 
innocent app writers to be hit by this kind of thing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
