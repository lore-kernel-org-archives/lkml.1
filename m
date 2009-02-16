Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbZBPXFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbZBPXFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZBPXFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:05:45 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38517 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZBPXFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:05:44 -0500
Date: Tue, 17 Feb 2009 00:05:32 +0100
From: Pavel Machek <pavel@suse.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arjan van de Ven <arjan@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090216230532.GI1370@ucw.cz>
References: <200902160010.16955.rjw@sisk.pl> <20090215164456.34aef7e8@infradead.org> <1234750360.26036.115.camel@pasglop> <20090215182012.3bc6b292@infradead.org> <1234754621.26036.120.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234754621.26036.120.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-02-16 14:23:41, Benjamin Herrenschmidt wrote:
> On Sun, 2009-02-15 at 18:20 -0800, Arjan van de Ven wrote:
> > what this needs is a separation between "interface down, all off" and
> > "interface down enough so that link detection works".
> > Some NICs can go all the way down and still do link detection, others
> > cannot. This is obviously something the driver will know, nothing else
> > in the system should know.
> 
> Sure, my point was just that the driver cannot make the decision to go
> all-off (and thus not detect link) without some kind of user setting
> allowing it to do so.

Maybe we need ifconfig eth0 reallyreallydown ?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
