Return-Path: <linux-kernel-owner+w=401wt.eu-S1762795AbYCDASs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762795AbYCDASs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 19:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbYCDASi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 19:18:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:39702 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbYCDASh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 19:18:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=akCnvRnaj8PhdMP22zh5XDGcMkjzrA5X1GF/r6ueyjHRdZM4yVaX0CCIu4uSJ/f+pGPDtMoQSf8MbWor3bOii/uZf+JIiiCDYAbmnMnPm3O8G0ucVP4w/m7LD3qgJOUPPS54vcpmAGcPBWN7/A0oYP8JN7mw4Gkt+EbfgS6tu+w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: -rc3 regression (was Re: 2.6.25-rc2 + smartd = hang )
Date: Tue, 4 Mar 2008 01:33:07 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <20080228143854.6350093C855@tippex.mynet.homeunix.org> <200803040116.42764.bzolnier@gmail.com>
In-Reply-To: <200803040116.42764.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803040133.07736.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008, Bartlomiej Zolnierkiewicz wrote:

> Untested patch which may help in case that set_pio_mode() raced with
> the queueing of the special request and block layer doesn't call
> ->request_fn_proc again if we were preempted previously (if PREEMPT=y).

I need some sleep...  this patch is not going to help (though disabling
PREEMPT may be worth a try).  Sorry for the confusion.

Bart
