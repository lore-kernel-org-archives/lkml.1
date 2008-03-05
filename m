Return-Path: <linux-kernel-owner+w=401wt.eu-S1751734AbYCEKwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbYCEKwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 05:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYCEKvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 05:51:50 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:47606 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159AbYCEKvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 05:51:49 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: -rc3 regression (was Re: 2.6.25-rc2 + smartd = hang ) 
In-reply-to: <200803042346.21403.bzolnier@gmail.com> 
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <200803040133.07736.bzolnier@gmail.com> <20080304095701.DDF762DC027@tippex.mynet.homeunix.org> <200803042346.21403.bzolnier@gmail.com>
Comments: In-reply-to Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
   message dated "Tue, 04 Mar 2008 23:46:21 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 05 Mar 2008 11:51:38 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080305105138.B140C93C87D@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JWrDp-0001FA-7R.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1JWrDp-0001FA-7R 85eee42d79d65463149202dd4de59abf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bzolnier@gmail.com said:
> and see if manually reverting only ide-taskfile.c change fixes the problem
> (so we know that we are looking at the right place). 

It does. Reverting the ide-taskfile.c change fixes it.



