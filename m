Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbZFGVDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbZFGVDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 17:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbZFGVD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 17:03:28 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:46303 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbZFGVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 17:03:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=r8uTvS7A5ZUPwDtpvMs0t+3qIU6bauOtgAvX7Md7g1403yTrb6RjD/83yfSE/xBCZ+
         XI2ncE5c4NSrSk5Crgm2Lr1O1vQCI7uhbj61ePn9jQNyggSQC9pF2rg1eZUpmru10B7c
         XXGLl8oWVDQHrXjmstt2+hpm4uvmqr5PrAooQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [git pull] IDE fixes
Date: Sun, 7 Jun 2009 23:08:13 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200906071444.33047.bzolnier@gmail.com> <20090607210701.78103188@lxorguk.ukuu.org.uk> <1244407185.8262.178.camel@mulgrave.site>
In-Reply-To: <1244407185.8262.178.camel@mulgrave.site>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906072308.13913.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009 22:39:45 James Bottomley wrote:
> On Sun, 2009-06-07 at 21:07 +0100, Alan Cox wrote:
> > > > [ I also tried to encourage libata developers to look into making the needed
> > > >   libata changes (see my initial posting of HPA patches) and I will still be
> > > >   glad to help with libata patches if somebody would like to work on them
> > > >   (Robert? Tejun?). ]
> > > 
> > > OK, so back off on the 2.6.30-rc7 release of this and I'll undertake to
> > > get libata engaged for integrating this into both subsystems for
> > > 2.6.31 ... does that sound fair?
> > 
> > libata already is, and I've been following and reviewing the patches. The
> > problem remaining is basically that this is not the time to merge
> > it.
> 
> Actually, I was talking about the fallback to disabling heuristic which
> this patch set introduces, and which would fix bug 13365 if it were
> applied to libata, but which is the bit I think needs some testing.

My patches fix the root cause of the problem and alleviate the issue for
all new installations.  In libata's case more testing is needed because
the libata's default is to keep HPA enabled (which is proper for modern
systems).

Once you get all HPA details (it is a complicated mess -- that is why
kernel/distributions couldn't get it right for years) you will see the
overall picture of the problem -- the work on multiple fronts at once
(including user-space) is needed to fix it properly.
