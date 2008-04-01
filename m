Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbYDAUQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbYDAUQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757103AbYDAUQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:16:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48181 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756948AbYDAUQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:16:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: benh@kernel.crashing.org
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 6)
Date: Tue, 1 Apr 2008 22:16:07 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>
References: <200803292317.50218.rjw@sisk.pl> <1207037741.23143.81.camel@nigel-laptop> <1207038460.10388.214.camel@pasglop>
In-Reply-To: <1207038460.10388.214.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804012216.08318.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of April 2008, Benjamin Herrenschmidt wrote:
> 
> On Tue, 2008-04-01 at 19:15 +1100, Nigel Cunningham wrote:
> > > + *   However, drivers may NOT assume anything about the availability of the
> > > + *   user space at that time and it is not correct to request firmware from
> > > + *   within @prepare() (it's too late to do that).
> > 
> > That doesn't sound good. It would be good to be able to get drivers to
> > request firmware early in the process.
> 
> Agreed. Prepare() should still allow request_firmware and full userspace
> communication / helper usage.

This documents the current state which is that we have the freezer and we have
drivers that rely on it.

I can remove the comment, but then someone will invent ->prepare() relying
on the availability of the user space at this point and that won't work.

Thanks,
Rafael
