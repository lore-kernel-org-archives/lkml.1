Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbXIMONb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbXIMONb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756712AbXIMONS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:13:18 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:33830 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419AbXIMONQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:13:16 -0400
Date: Thu, 13 Sep 2007 15:13:06 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jeff Garzik <jgarzik@pobox.com>
cc: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1250-mac.c: De-typedef, de-volatile, de-etc...
In-Reply-To: <46E8B56E.7060705@pobox.com>
Message-ID: <Pine.LNX.4.64N.0709131506040.31069@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0709101310030.25038@blysk.ds.pg.gda.pl>
 <46E8B56E.7060705@pobox.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, Jeff Garzik wrote:

> > Remove typedefs, volatiles and convert kmalloc()/memset() pairs to
> > kcalloc().  Also reformat the surrounding clutter.
> > 
> > Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> > ---
> 
> ACK, but patch does not apply cleanly to netdev-2.6.git#upstream (nor -mm)

 Hmm, works fine with linux-2.6.git#master.  I do not recall any recent 
activity with this driver -- I wonder what the difference is.  Let me 
see...

  Maciej
