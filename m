Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbXIDU1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbXIDU1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 16:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbXIDU1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 16:27:01 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:35382 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbXIDU1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 16:27:00 -0400
X-Greylist: delayed 1218 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2007 16:27:00 EDT
Subject: Re: [PATCH] Fix a potential NULL pointer dereference in
	usbat_check_status()  in drivers/usb/storage/shuttle_usbat.c
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Micah Gruber <micah.gruber@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, gregkh@suse.de
In-Reply-To: <20070904110651.GB5126@kernel.dk>
References: <46DD1661.4070500@gmail.com>  <20070904110651.GB5126@kernel.dk>
Content-Type: text/plain; charset=utf-8
Date: Tue, 04 Sep 2007 21:57:49 +0200
Message-Id: <1188935869.19079.3.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tir, 04 09 2007 kl. 13:06 +0200, skrev Jens Axboe:
> On Tue, Sep 04 2007, Micah Gruber wrote:
> > This patch fixes a potential null dereference bug where we dereference us before a null check. This patch simply moves the dereferencing after the null check.
> > 
> > Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
> 
> Be careful with stuff like that, if you actually look at the code, a us
> == NULL doesn't seem to be possible (or usbat_flash_transport() would
> have oopsed before).
> 
If that is true, then
        if (!us)
                return USB_STOR_TRANSPORT_ERROR;
is utterly pointless.


Simon Holm Thøgersen

