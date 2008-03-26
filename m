Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbYCZXpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbYCZXpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYCZXoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:44:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:37291 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbYCZXox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:44:53 -0400
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 4)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>
In-Reply-To: <47EADBD0.6040400@suse.de>
References: <200803262353.30566.rjw@sisk.pl>
	 <200803270003.51570.rjw@sisk.pl>  <47EADBD0.6040400@suse.de>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 10:43:02 +1100
Message-Id: <1206574982.6926.53.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-27 at 02:27 +0300, Alexey Starikovskiy wrote:
> Rafael J. Wysocki wrote:
> > This is the 4th revision of the patch.
> > + * struct pm_noirq_ops - device PM callbacks executed with interrupts disabled
> > + *
> > + * The following callbacks included in 'struct pm_noirq_ops' are executed with
> > + * the nonboot CPUs switched off and with interrupts disabled on the only
> > + * functional CPU.  They also are executed with the PM core list of devices
> > + * locked, so they must NOT unregister any devices.
> > + *
> > + * @suspend_noirq: Complete the operations of ->suspend() by carrying out any
> > + *	actions required for suspending the device that need interrupts to be
> > + *	disabled
> IMHO, no need to add _noirq in both struct and struct members.
> pm_noirq->suspend_noirq does not look good...

There is absolutely no point getting a second struct anymore.

BTW. I haven't had a chance to review the rest of the discussion on that
thread yet, been busy with other things, I'll try to go back to it today
or tomorrow.

Cheers,
Ben.

