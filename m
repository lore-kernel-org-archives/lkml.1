Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbYDMX2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbYDMX2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYDMX2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:28:45 -0400
Received: from mail.crca.org.au ([67.207.131.56]:34634 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbYDMX2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:28:44 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 8)
From: Nigel Cunningham <ncunningham@crca.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
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
In-Reply-To: <200804140117.34554.rjw@sisk.pl>
References: <200804040111.15255.rjw@sisk.pl>
	 <1208126822.6958.63.camel@pasglop> <1208128289.29577.25.camel@nigel-laptop>
	 <200804140117.34554.rjw@sisk.pl>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Mon, 14 Apr 2008 09:29:30 +1000
Message-Id: <1208129370.29577.30.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2008-04-14 at 01:17 +0200, Rafael J. Wysocki wrote:
> On Monday, 14 of April 2008, Nigel Cunningham wrote:
> > Hi Rafael etc.
> 
> Hi,
>  
> > On Mon, 2008-04-14 at 08:47 +1000, Benjamin Herrenschmidt wrote:
> > > > Well, I'm not sure and I'm not going to introduce the change right now, after
> > > > the paches have been included in -mm.
> > > > 
> > > > That would require quite some changes in the core code that I'd prefer to
> > > > avoid for now.  We can do something like this in a separate patch series after
> > > > the present one settles down a bit.
> > > 
> > > I disagree.
> > > 
> > > Doing it later would introduce yet another major semantic change.
> > > 
> > > I think we should get it right now. There's no hurry in pushing things
> > > especially if they aren't quite right.
> > > 
> > > The ability for prepare() callbacks to sync with userland,
> > > request_firmware, etc... is an important feature that's been needed for
> > > some time imho.
> > > 
> > > Ben.
> > 
> > I agree. These calls have already been changing far too often in
> > mainline. I know it's all been necessary but please, can we try to make
> > one set of changes and just get it right this time?
> 
> Sorry, what exactly has been changing too often?  Device suspend callbacks??
> They haven't changed since pm_message_t was introduced.

I'm thinking of driver models calls for both hibernation and suspend to
ram, both names and semantics as to what is called when.

Regards,

Nigel

