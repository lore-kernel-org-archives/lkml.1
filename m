Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbXHBMF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbXHBMF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbXHBMFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:05:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52107 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbXHBMFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:05:14 -0400
Date: Thu, 2 Aug 2007 14:05:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       trenn@suse.de, pavel@ucw.cz, mjg59@srcf.ucam.org, lenb@kernel.org
Subject: Re: 2.6.22 regression: thermal trip points
Message-ID: <20070802120511.GA440@one.firstfloor.org>
References: <46B1988C.3090302@t-online.de> <20070802015248.45a40717.akpm@linux-foundation.org> <p731wemnre6.fsf@bingen.suse.de> <20070802120014.1d08830a@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802120014.1d08830a@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Set a taint flag, 

That's hardly any useful if the machine is dead afterwards.

> print a loud message 

Neither.

You'll just end up with "Linux destroyed my laptop" headlines all 
over the internet and rightfully very annoyed users.

> Or have you forgotten the original Unix
> philosophy too ?

The philosophy didn't include physically destroying hardware
as far as I know.

> > > Here we had obviously-useful-to-you functionality which was taken away
> > > without, afaik, providing any alternative.
> > 
> > I don't think it's that unreasonable to require source code modifications
> > for anything that can kill hardware.
> 
> As root you can erase the bios, 

We don't ship the devbios driver for good reasons.

> lock the hard disk with a random
> password, reflash your video card .... 

That all requires significant effort and custom software. It's not that we 
have a one liner echo destroy > /sys/.../flash-bios. 

-Andi

