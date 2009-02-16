Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbZBPDaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbZBPDaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 22:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbZBPDao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 22:30:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:53590 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbZBPDan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 22:30:43 -0500
Date: Sun, 15 Feb 2009 19:30:37 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090215193037.3e3ebeab@infradead.org>
In-Reply-To: <1234754621.26036.120.camel@pasglop>
References: <200902160010.16955.rjw@sisk.pl>
	<20090215164456.34aef7e8@infradead.org>
	<1234750360.26036.115.camel@pasglop>
	<20090215182012.3bc6b292@infradead.org>
	<1234754621.26036.120.camel@pasglop>
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

On Mon, 16 Feb 2009 14:23:41 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Sun, 2009-02-15 at 18:20 -0800, Arjan van de Ven wrote:
> > what this needs is a separation between "interface down, all off"
> > and "interface down enough so that link detection works".
> > Some NICs can go all the way down and still do link detection,
> > others cannot. This is obviously something the driver will know,
> > nothing else in the system should know.
> 
> Sure, my point was just that the driver cannot make the decision to go
> all-off (and thus not detect link) without some kind of user setting
> allowing it to do so.

to a very large degree, "want linkdetection" is a form of keeping the
device open.. even if the current code doesn't quite work that way
(maybe it should)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
