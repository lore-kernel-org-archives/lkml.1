Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbXJBHOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbXJBHOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbXJBHOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:14:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:59346 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXJBHOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:14:48 -0400
Subject: Re: [PATCH] mmc: Disabler for Ricoh MMC controller
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Philip Langdale <philipl@overt.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>, sdhci-devel@list.drzeus.cx,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4701D0BA.7080404@overt.org>
References: <4701B9AB.5070308@overt.org>  <1191300236.6310.60.camel@pasglop>
	 <1191300334.6310.62.camel@pasglop>  <4701D0BA.7080404@overt.org>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 17:14:34 +1000
Message-Id: <1191309274.6310.108.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-01 at 22:01 -0700, Philip Langdale wrote:
> Benjamin Herrenschmidt wrote:
> > On Tue, 2007-10-02 at 14:44 +1000, Benjamin Herrenschmidt wrote:
> >> On Mon, 2007-10-01 at 20:23 -0700, Philip Langdale wrote:
> >>> Thanks to Matt Domsch and Rezwanul Kabir at Dell, we know how to disable the
> >>> MMC controller on the multi-function Ricoh R5C832. The MMC controller needs
> >>> to be disabled or it will steal MMC cards from the SD controller where they
> >>> would otherwise be supported by the Linux SDHCI driver.
> >> Why can't that be a quirk instead ?
> > 
> > That is, a global quirk or a quirk in the SDHCI driver...
> 
> Pierre doesn't want a quirk.

Hrm... allright, tho having this "disabler" driver is butt ugly too ...
especially since it needs to whack registers in another function, that's
really quirkland :-)

Oh well...

Ben.


