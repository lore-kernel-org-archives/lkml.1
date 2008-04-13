Return-Path: <linux-kernel-owner+w=401wt.eu-S1758366AbYDMXRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366AbYDMXRX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYDMXRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:17:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37973 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbYDMXRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:17:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 8)
Date: Mon, 14 Apr 2008 01:17:33 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: benh@kernel.crashing.org, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200804040111.15255.rjw@sisk.pl> <1208126822.6958.63.camel@pasglop> <1208128289.29577.25.camel@nigel-laptop>
In-Reply-To: <1208128289.29577.25.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140117.34554.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, Nigel Cunningham wrote:
> Hi Rafael etc.

Hi,
 
> On Mon, 2008-04-14 at 08:47 +1000, Benjamin Herrenschmidt wrote:
> > > Well, I'm not sure and I'm not going to introduce the change right now, after
> > > the paches have been included in -mm.
> > > 
> > > That would require quite some changes in the core code that I'd prefer to
> > > avoid for now.  We can do something like this in a separate patch series after
> > > the present one settles down a bit.
> > 
> > I disagree.
> > 
> > Doing it later would introduce yet another major semantic change.
> > 
> > I think we should get it right now. There's no hurry in pushing things
> > especially if they aren't quite right.
> > 
> > The ability for prepare() callbacks to sync with userland,
> > request_firmware, etc... is an important feature that's been needed for
> > some time imho.
> > 
> > Ben.
> 
> I agree. These calls have already been changing far too often in
> mainline. I know it's all been necessary but please, can we try to make
> one set of changes and just get it right this time?

Sorry, what exactly has been changing too often?  Device suspend callbacks??
They haven't changed since pm_message_t was introduced.

Thanks,
Rafael
