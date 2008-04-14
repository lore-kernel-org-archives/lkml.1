Return-Path: <linux-kernel-owner+w=401wt.eu-S1760562AbYDNUy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562AbYDNUy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbYDNUyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:54:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:42137 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbYDNUyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:54:50 -0400
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 8)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg KH <greg@kroah.com>, pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0804141049370.2236-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0804141049370.2236-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 06:47:36 +1000
Message-Id: <1208206056.6958.176.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-14 at 10:51 -0400, Alan Stern wrote:
> On Sun, 13 Apr 2008, David Brownell wrote:
> 
> > I sort of agree.  Looking at it from a whole-system perspective,
> > suspending needs to be able to chitchat with userspace ... and I
> > don't think that can be done *before* writing to /sys/power/state
> > in an acceptably generic/portable way.  (Briefly, applications
> > need to have clean stopping points and be able to arrange system
> > wakeup.  They may well have more work to do than most drivers.)
> 
> Pavel's recent work aside, the only way to initiate a system sleep is 
> from userspace.  So it seems natural for all application notifications 
> to be made by the initiating program, perhaps via dbus.

No. Certainly not via dbus.

Ben.


