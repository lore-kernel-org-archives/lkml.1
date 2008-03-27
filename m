Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbYC0ALK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbYC0ALK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 20:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbYC0AK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 20:10:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:37192 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbYC0AKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 20:10:55 -0400
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 4)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>
In-Reply-To: <200803270054.58546.rjw@sisk.pl>
References: <200803262353.30566.rjw@sisk.pl> <47EADBD0.6040400@suse.de>
	 <1206574982.6926.53.camel@pasglop>  <200803270054.58546.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 11:06:43 +1100
Message-Id: <1206576403.6926.62.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > There is absolutely no point getting a second struct anymore.
> 
> I obviously disagree with that opinion, so please elaborate.

Well, what does it bring you ? Why can't it be one struct ? To save
space in the data area ? I don't think it makes things much cleaner. But
I won't fight a war for it, now that they are clearly named differently
and things like prepare/complete are no longer in "noirq", it's
semantically the same thing as having the fields in one structure, so
it's mostly cosmetic.

Ben.



