Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbXFCWdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbXFCWdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 18:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXFCWdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 18:33:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbXFCWdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 18:33:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm 1/2] PM: Introduce hibernation and suspend notifiers
Date: Mon, 4 Jun 2007 00:38:53 +0200
User-Agent: KMail/1.9.5
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
References: <200705272229.21263.rjw@sisk.pl> <200706020243.20117.rjw@sisk.pl> <20070603164143.GB4093@ucw.cz>
In-Reply-To: <20070603164143.GB4093@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706040038.54161.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 3 June 2007 18:41, Pavel Machek wrote:
> Hi!
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Make it possible to register hibernation and suspend notifiers, so that
> > subsystems can perform hibernation-related or suspend-related operations that
> > should not be carried out by device drivers' .suspend() and .resume() routines.
> 
> One more question: what will we call in suspend-to-both case? I do not
> think we can call SUSPEND_PREPARE with frozen tasks, so just one call
> to HIBERNATION_PREPARE?

Yes, right now it should work this way.

> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Ack.

Thanks!

Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
