Return-Path: <linux-kernel-owner+w=401wt.eu-S1764262AbXIMRVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764262AbXIMRVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 13:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763964AbXIMRU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 13:20:59 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:54055 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbXIMRU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 13:20:58 -0400
Date: Thu, 13 Sep 2007 18:20:45 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Robin Holt <holt@sgi.com>
cc: Chuck Ebbert <cebbert@redhat.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: Possible hang inside interrupt handler on sata_promise.
In-Reply-To: <20070913171349.GD26213@lnx-holt.americas.sgi.com>
Message-ID: <Pine.LNX.4.64N.0709131818180.31069@blysk.ds.pg.gda.pl>
References: <20070912131904.GW14474@lnx-holt.americas.sgi.com>
 <46E95E5D.2050305@redhat.com> <20070913171349.GD26213@lnx-holt.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007, Robin Holt wrote:

> Is there any way on typical motherboards to send an NMI?  On Altix boxes,
> we can use the system controller to send an NMI.  I have found some
> motherboards appear to have an NMI line.  Is there anything like that
> on i386?  Maybe I am missing the issue entirely.  Does deadlock inside
> an IRQ handler seem plausible?

 There are various ways possible to send an NMI on a typical i386 box of 
these days; the easiest is probably the NMI watchdog -- see the 
"nmi_watchdog" kernel option.

  Maciej
