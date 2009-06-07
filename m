Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbZFGO1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbZFGO1o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZFGO1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:27:36 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:34504 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZFGO1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=r3L6lbfw0pVH7vWkCz9hGJoOsOfXdiQ7WZDbwl/xGOK9fnbDahGkNWWlP9ArMBRNhu
         1hNSUhelj1IQv8s5OCeiXCgNt6NaTGyfUUjOJAGS6zMDQDFNiSBjTrFOE+6ydRojbdOC
         vOzBZ1vZ4rulGy56nQ4k8HwlRmDGLrECIhskQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git pull] IDE fixes
Date: Sun, 7 Jun 2009 16:32:30 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200906071444.33047.bzolnier@gmail.com> <20090607152151.3cb01901@lxorguk.ukuu.org.uk>
In-Reply-To: <20090607152151.3cb01901@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906071632.30914.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009 16:21:51 Alan Cox wrote:
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

If you want to discuss any code that I push upstream then *please* quote
it in your mails so we all can see what parts you question and discuss it
based on technical merits.
