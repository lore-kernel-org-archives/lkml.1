Return-Path: <linux-kernel-owner+w=401wt.eu-S2992783AbXCHABP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992783AbXCHABP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992782AbXCHABP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:01:15 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35375 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992778AbXCHABO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:01:14 -0500
Date: Thu, 8 Mar 2007 01:05:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Use correct IDE error recovery
Message-ID: <20070308010533.4cef7934@lxorguk.ukuu.org.uk>
In-Reply-To: <200703072216.08295.bzolnier@gmail.com>
References: <20070221012304.GC1777@freefall.freebsd.org>
	<200703072216.08295.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wednesday 21 February 2007, Suleiman Souhlal wrote:
> > IDE error recovery is using WIN_IDLEIMMEDIATE which was only valid for
> > IDE V1 and IDE V2.  Modern drives will not be able to recover using
> > this error handling.  The correct thing to do is issue a SRST followed
> > by a SET_FEATURES.
> 
> This change looks fine, indeed we are better of using SRST + SET_FEATURES
> than IDLE_IMMEDIATE.
> 
> > Signed-off-by:	Suleiman Souhlal <suleiman@google.com>

Acked-by: Alan Cox <alan@redhat.com>

And this is well worth doing - IDLEIMMEDIATE blows the mind of some later
drive firmware that doesn't expect to be treated in an IDE v1 manner.


Alan
