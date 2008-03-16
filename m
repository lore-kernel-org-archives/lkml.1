Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbYCPPA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbYCPPA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 11:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYCPPAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 11:00:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:5206 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbYCPPAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 11:00:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=vIkX1e6Y4q2R1CA1MMFAXst+ohFoOly1As6BDiwU+UFTmpQaGEmMTi6X65b+OTBN0nQxXOVt807saoZf9smmlMIb9zhInKjwXYlLeA0H/kKjJvlortLTAFCHYVCxPXr1EgV6fzJyqzWyEAphtWDzZF8jZiNLcCWZOQ+IFtPzSso=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: Linux 2.6.25-rc4
Date: Sun, 16 Mar 2008 16:14:39 +0100
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803161529.48527.bzolnier@gmail.com> <20080316142901.015342DC044@tippex.mynet.homeunix.org>
In-Reply-To: <20080316142901.015342DC044@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803161614.39938.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008, Anders Eriksson wrote:
> 
> bzolnier@gmail.com said:
> > This commit is also _after_ the previously "guilty" one (commit
> > 852738f39258deafb3d89c187cb1a4050820d555)?
> 
> Yep.
> 
> > IIRC we've agreed that bisection between 2.6.24 and commit 8527* was needed?
> 
> I did that first, and it pointed to  8527* as the bad one. During this bisect 
> I took care to always start from a 2.6.24 .config, and do a make oldconfig from 
> that. A clean series of good emerged.. Unfortunately I don't have the configs 
> from the previous runs saved.
> 
> Given this, I concluded that the configs had to play a role in making a 
> version go bad, so I decided to do another one between  8527* and 2.6.25-rc1
> always based on the  8527* config (which _worked_ when tested with the 2.6.24 
> config dragged forward. So the upped end of the first bisect was badly chosen)
> 
> The attahed was the result of that latter run...

Given that the problem manifested with 8527* in the past (w/ whatever config)
then 4d97* just cannot be a guilty commit (== the one introducing the problem).

IOW the 8527* and later commits just make the issue more likely to occur
(moreover there should be no difference in configs between 8527* and 4d97*).

I guess that re-doing bisection between 2.6.24 and 8527* may be fruitless
but maybe somebody has some idea how we can proceed further with debugging
the hang instead?  Jens/Ingo?

Thanks,
Bart
