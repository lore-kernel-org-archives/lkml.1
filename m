Return-Path: <linux-kernel-owner+w=401wt.eu-S1757746AbYFWFya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbYFWFya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 01:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbYFWFyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 01:54:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:60969 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbYFWFyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 01:54:18 -0400
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1214199343.8011.230.camel@pasglop>
References: <200806162124.43005.bzolnier@gmail.com>
	 <1213673979.8129.156.camel@pasglop> <1213674572.8129.159.camel@pasglop>
	 <200806171141.08865.bzolnier@gmail.com> <1214199343.8011.230.camel@pasglop>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 15:54:13 +1000
Message-Id: <1214200453.8011.232.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 15:35 +1000, Benjamin Herrenschmidt wrote:
> > This patch series (from yesterday, the rest of can be ignored) should
> > apply fine to the next revision of linux-next (later than -next-20080616,
> > it is not out yet), if you prefer upstream patches I can look into it
> > tonight.
> 
> Whatever last patches from you I have in my mailbox (ie. a serie of 4,
> one of them being superseeded by a "version 3" that you sent later on)
> doesn't apply on current linux next (ie 20080620).
> 
> I'll see if I can fix it up.

Don't panic. It looks like it's something else in linux-next that's
changing some ifdef's in the media-bay code which is causing that.

I managed to pull linux next at the merge point with your tree and
things apply. I'll use that to test.

Cheers,
Ben.


