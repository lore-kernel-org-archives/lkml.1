Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbYDNAH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbYDNAH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYDNAHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:07:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38161 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbYDNAHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:07:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 8)
Date: Mon, 14 Apr 2008 02:07:17 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Nigel Cunningham <ncunningham@crca.org.au>, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.0804131916420.3060-100000@netrider.rowland.org> <1208130513.6958.72.camel@pasglop>
In-Reply-To: <1208130513.6958.72.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140207.19340.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, Benjamin Herrenschmidt wrote:
> 
> On Sun, 2008-04-13 at 19:23 -0400, Alan Stern wrote:
> > 
> > Thus, in addition to making all the interface changes implied by the 
> > new callbacks, drivers would also have to change the way they
> > interact 
> > with userspace.  Yes, this will have to be done eventually in any
> > case, 
> > as the freezer goes away -- but it shouldn't have to be done right
> > now.
> 
> I disagree. The freezer can already be compiled out and is already not
> used on some architectures.

Please have a look at this thread:
http://lkml.org/lkml/2008/3/21/322
(in short, the reporter sees APM suspend breakage under stress, occuring
because APM uses our suspending of devices without the freezer).

It mostly appears to work without the freezer, but that's bacuse no one
actually does things that might break it.  I don't think we can rely on users
being so kind to us forever. :-)

Thanks,
Rafael
