Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYBWW7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYBWW7n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 17:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYBWW7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 17:59:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:25379 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYBWW7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 17:59:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=gN2kl5kRV05T/CcKcdjZ3A5q3YmW9VAVpOvjAhA2haLwadRCsNB4l+fu/NU8z5EVIWM3XNF7eLSIfdL8lQATxyD+RmkK4/9NNGbwgLWVAe/vIaiJfHf1YFAAd4reJEeB8shndlFVy9nDhEYlSblQomuXbc1wQNJQG++jRdFH4bU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: 2.6.25-rc2 + smartd = hang
Date: Sun, 24 Feb 2008 00:12:36 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Mark Lord <liml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <20080222213932.3403F93C12F@tippex.mynet.homeunix.org> <20080223221721.5C8502DC002@tippex.mynet.homeunix.org>
In-Reply-To: <20080223221721.5C8502DC002@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802240012.36571.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 23 February 2008, Anders Eriksson wrote:
> 
> aeriksson@fastmail.fm said:
> >> But at this point libata is working much better than the old IDE stuff, and
> >> it really is worth moving things over if you can. 
> >
> > Ok, I'll take a stab at that tomorrow. Two things... 
> 
> Having switched to ata_piix i can confirm that smartd doesn't hand the system 
> anymore.
> 
> Still.. There seem to be a bug vs. the old drivers somewhere. Will that be 
> addressed, or should there be a big warning for the old stuff (DEPRECATED?)

Could you try bisecting it down to the guilty commit using git-bisect?

[ the "old" stuff got few hundred commits in 2.6.25 ]

Thanks,
Bart
