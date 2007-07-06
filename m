Return-Path: <linux-kernel-owner+w=401wt.eu-S1762794AbXGFJBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762794AbXGFJBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbXGFJBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:01:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:47830 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758059AbXGFJBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:01:42 -0400
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
	RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       Miklos Szeredi <miklos@szeredi.hu>, pavel@ucw.cz, paulus@samba.org,
       johannes@sipsolutions.net, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org
In-Reply-To: <200707060913.24131.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0707051713440.2753-100000@iolanthe.rowland.org>
	 <200707052337.27066.oliver@neukum.org>  <200707060913.24131.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 18:59:13 +1000
Message-Id: <1183712354.3388.126.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 09:13 +0200, Rafael J. Wysocki wrote:
> 
> The only reason (I know of) why we don't handle uninterruptible tasks in the
> freezer is that we're afraid of the suspend process deadlocking with an
> uninterruptible task holding a lock, but AFAICS the probability of such an
> event is extremely small.

What would deadlock specifically ? One of the drivers trying to acquire
that lock ? It would be a driver bug then.

> Also, the powermac suspend will deadlock in such cases, so the fact that
> it doesn't deadlock means that they don't occur very often (if at all).

Ben.


