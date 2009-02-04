Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbZBDVkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbZBDVkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbZBDVkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:40:00 -0500
Received: from gate.crashing.org ([63.228.1.57]:47247 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbZBDVkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:40:00 -0500
Subject: Re: [PATCH 3/7] PCI PM: Fix saving of device state in
 pci_legacy_suspend
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frans Pop <elendil@planet.nl>
Cc: rjw@sisk.pl, jbarnes@virtuousgeek.org, torvalds@linux-foundation.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <200902041115.00842.elendil@planet.nl>
References: <200902040154.36018.rjw@sisk.pl>
	 <200902040159.10258.rjw@sisk.pl> <200902040159.10258.rjw@sisk.pl>
	 <1233712613.16867.136.camel@pasglop> <200902041115.00842.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 08:38:22 +1100
Message-Id: <1233783502.4612.7.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 11:14 +0100, Frans Pop wrote:
> Benjamin Herrenschmidt wrote:
> > Minor nit: Should the warning be preceeded by a message ? The reason is,
> > right now, all we get is a backtrace, it doesn't actually tell you which
> > device or driver caused it which makes it pretty pointless.
> > 
> > I think you should add a printk(KERN_ERR... just before that which gives
> > those informations along with a little blurb along the lines of "driver
> > changed device state without saving config space state").
> 
> That is actually already included in the patch (through drv->suspend):

How so ? I've had such backtraces with no other info in my log...

Ben.


