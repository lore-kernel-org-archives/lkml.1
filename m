Return-Path: <linux-kernel-owner+w=401wt.eu-S932082AbYBZWYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbYBZWYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762223AbYBZWXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:23:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:27382 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbYBZWX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:23:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=pDNEvgttambvd1muxPmyNQTfHi4mQ5Tp49MIB4eADzI43C6aU72Lp/6oYc384V4GxyHL4hpKbDsnhu6kaHk48nwC5+O4f5lUzfkUGBCjm+FaYfPW/SWGnL7qX/NzV1oDBi6qra6lm9z8CUQ3sXf7E1CMfTq5Uvujt4it5rw/Vrk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: 2.6.25-rc2 + smartd = hang
Date: Tue, 26 Feb 2008 20:54:12 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <200802241654.49150.bzolnier@gmail.com> <20080226082056.7519C93C195@tippex.mynet.homeunix.org>
In-Reply-To: <20080226082056.7519C93C195@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802262054.12806.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008, Anders Eriksson wrote:
> > bzolnier@gmail.com said:
> > > Could you try bisecting it down to the guilty commit using git-bisect?
> > > [ the "old" stuff got few hundred commits in 2.6.25 ]
> > > Thanks, Bart 
> 
> Ok, I got this:
> 852738f39258deafb3d89c187cb1a4050820d555 is first bad commit
> commit 852738f39258deafb3d89c187cb1a4050820d555
> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date:   Sat Jan 26 20:13:12 2008 +0100
> 
>     ide: convert "empty" REQ_TYPE_ATA_CMD requests to use REQ_TYPE_ATA_TASKFILE
> 
>     Based on the previous work by Tejun Heo.
> 
>     There should be no functionality changes caused by this patch.
> 
>     Cc: Tejun Heo <htejun@gmail.com>
>     Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> :040000 040000 e65605824ccc1c8bda2ab6f917b5457d36c5537e 5fb514a261b13494c5e9c035f9e7598276ce8839 M      drivers
> 
> I'll run with the last known good version for a while,so if there's any more 
> testing needed let me know.

Thanks.

Unfortunately nothing seems wrong with the patch... :(

I'll take a closer look when I have some more time...

Bart
