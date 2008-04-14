Return-Path: <linux-kernel-owner+w=401wt.eu-S1761978AbYDNU40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761978AbYDNU40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbYDNU4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:56:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45285 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbYDNU4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:56:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 8)
Date: Mon, 14 Apr 2008 22:56:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200804040111.15255.rjw@sisk.pl> <20080414105522.GA4716@ucw.cz> <1208205952.6958.174.camel@pasglop>
In-Reply-To: <1208205952.6958.174.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804142256.03514.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, Benjamin Herrenschmidt wrote:
> 
> On Mon, 2008-04-14 at 12:55 +0200, Pavel Machek wrote:
> > On Mon 2008-04-14 08:47:02, Benjamin Herrenschmidt wrote:
> > > 
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
> > 
> > 'allow load_firmware from prepare that was not allowed before' is not 'major'.
> 
> Having user space fully operating is major.

Please tell me what exactly is wrong with doing things that depend on the
user space being available from notifiers.

Thanks,
Rafael
