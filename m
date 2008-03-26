Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYCZXzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYCZXzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbYCZXy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:54:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41946 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbYCZXy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:54:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: benh@kernel.crashing.org
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 4)
Date: Thu, 27 Mar 2008 00:54:57 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>
References: <200803262353.30566.rjw@sisk.pl> <47EADBD0.6040400@suse.de> <1206574982.6926.53.camel@pasglop>
In-Reply-To: <1206574982.6926.53.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803270054.58546.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 of March 2008, Benjamin Herrenschmidt wrote:
> 
> On Thu, 2008-03-27 at 02:27 +0300, Alexey Starikovskiy wrote:
> > Rafael J. Wysocki wrote:
> > > This is the 4th revision of the patch.
> > > + * struct pm_noirq_ops - device PM callbacks executed with interrupts disabled
> > > + *
> > > + * The following callbacks included in 'struct pm_noirq_ops' are executed with
> > > + * the nonboot CPUs switched off and with interrupts disabled on the only
> > > + * functional CPU.  They also are executed with the PM core list of devices
> > > + * locked, so they must NOT unregister any devices.
> > > + *
> > > + * @suspend_noirq: Complete the operations of ->suspend() by carrying out any
> > > + *	actions required for suspending the device that need interrupts to be
> > > + *	disabled
> > IMHO, no need to add _noirq in both struct and struct members.
> > pm_noirq->suspend_noirq does not look good...
>
> There is absolutely no point getting a second struct anymore.

I obviously disagree with that opinion, so please elaborate.

> BTW. I haven't had a chance to review the rest of the discussion on that
> thread yet, been busy with other things, I'll try to go back to it today
> or tomorrow.

OK

Thanks,
Rafael
