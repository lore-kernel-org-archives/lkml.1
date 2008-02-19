Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbYBSR3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbYBSR3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 12:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbYBSR30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 12:29:26 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:62182 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752959AbYBSR3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:29:25 -0500
Date: Tue, 19 Feb 2008 09:23:04 -0800
From: Daniel Walker <dwalker@mvista.com>
To: matthias@kaehlcke.net
Cc: wolfgang@iksw-muees.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 2/3] Convert ccp->readmutex in a mutex
Message-ID: <20080219172304.GB9896@dwalker1.mvista.com>
References: <20080218194533.185137318@kaehlcke.net> <20080218194533.903955589@kaehlcke.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218194533.903955589@kaehlcke.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 08:45:35PM +0100, matthias@kaehlcke.net wrote:
> @@ -1391,7 +1391,7 @@
>  
>  	/* Initialize device descriptor */
>  	init_MUTEX( &ccp->mutex);
> -	init_MUTEX( &ccp->readmutex);
> +	mutex_init(&ccp->readmutex);
>          auerbuf_init (&ccp->bufctl);
>          ccp->scontext.id = AUH_UNASSIGNED;
>          ccp->scontext.dispatch = auerchar_ctrlread_dispatch;

Whitespace problems here? Might be good to do a checkpatch cleanup on this one too ..

Daniel
