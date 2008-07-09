Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbYGIVVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbYGIVVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbYGIVVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:21:24 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49466 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756307AbYGIVVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:21:22 -0400
Date: Wed, 9 Jul 2008 17:20:24 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk, mchan@broadcom.com, dwmw2@infradead.org,
       bastian@waldi.eu.org, linux-kernel@vger.kernel.org
Subject: Re: request_firmware vs. resume (was Re: [PATCH] bnx2 - use
	request_firmware())
Message-ID: <20080709212024.GB8517@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
	David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
	mchan@broadcom.com, dwmw2@infradead.org, bastian@waldi.eu.org,
	linux-kernel@vger.kernel.org
References: <20080707221950.3dfba435@the-village.bc.nu> <20080708.015838.245133409.davem@davemloft.net> <20080709202547.GD11006@ucw.cz> <200807092313.55777.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807092313.55777.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 11:13:54PM +0200, Rafael J. Wysocki wrote:
> > Be careful about request_firmware. Doing it right w.r.t.
> > suspend/resume is quite tricky: you have to load it from userspace
> > before kernel starts, so that you can use it during resume...
> 
> Rather, you have to cache it in memory before your ->suspend() is invoked.

Translation: so much for saving "non-swappable kernel memory".
Unless, of course we add a pre-suspend hook.  (Which doesn't exist
yet, AFAICT from a quick perusal of Documentation/power/devices.txt.)


     	    	   	 	    - Ted
