Return-Path: <linux-kernel-owner+w=401wt.eu-S1764313AbXIMD6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764313AbXIMD6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 23:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758570AbXIMD6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 23:58:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40610 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832AbXIMD6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 23:58:43 -0400
Message-ID: <46E8B56E.7060705@pobox.com>
Date: Wed, 12 Sep 2007 23:58:38 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1250-mac.c: De-typedef, de-volatile, de-etc...
References: <Pine.LNX.4.64N.0709101310030.25038@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0709101310030.25038@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
>  Remove typedefs, volatiles and convert kmalloc()/memset() pairs to
> kcalloc().  Also reformat the surrounding clutter.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  Per your request, Andrew, a while ago.  It builds, runs, passes 
> checkpatch.pl and sparse.  No semantic changes.
> 
>  Please apply,
> 
>   Maciej

ACK, but patch does not apply cleanly to netdev-2.6.git#upstream (nor -mm)


