Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbZFGOjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbZFGOjP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbZFGOjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:39:00 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56566 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993AbZFGOi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:38:59 -0400
Subject: Re: [git pull] IDE fixes
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090607152151.3cb01901@lxorguk.ukuu.org.uk>
References: <200906071444.33047.bzolnier@gmail.com>
	 <20090607152151.3cb01901@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 09:38:56 -0500
Message-Id: <1244385536.8262.5.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-07 at 15:21 +0100, Alan Cox wrote:
> > diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> > index 99e33ef..4bc2c43 100644
> > --- a/fs/partitions/check.c
> > +++ b/fs/partitions/check.c
> 
> 
> You seriously want to add code to the core partition handling logic
> moments before release when we know we have all sorts of devices with
> weird behaviours ?
> 
> This should be .31 stuff where we can take the time to see how it works
> on all sorts of weird real world devices (eg those with 2K sector size)
> and the like.

Absolutely seconded.

Plus this is only one of the proposals for dealing with IDE native sizes
moving through the process.  The other one is in libata with the gendisk
proposal for alt size instead of your set_capacity callback.   The last
thing we want is two separate mechanisms for this, so trying to push
anything upstream before we have agreement on direction is premature ...
trying to send a feature as a bug fix is doubly so.

James


