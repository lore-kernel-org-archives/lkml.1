Return-Path: <linux-kernel-owner+w=401wt.eu-S1759952AbXEPJ4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952AbXEPJ4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbXEPJzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:55:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:14242 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212AbXEPJzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=jpBKS2HPUKjdpLCspdEMPr+Mc4a/8xQd5jbeAortU5k2sudmCgjm5mJxYIGR6KKLRIeOtzFsYBPiPGarEu6DXxdApO7ttMordjDKR5JVIPlHpVCAnPkS6fNHnU2xEfWortcPdd7Ca2fEXe+ih0lbCszSw6qXTRzw2MadP7AY1eA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git patches] IDE updates/fixes
Date: Wed, 16 May 2007 12:07:57 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200705160127.55430.bzolnier@gmail.com> <alpine.LFD.0.98.0705151847160.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705151847160.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705161207.57716.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007, Linus Torvalds wrote:
> 
> On Wed, 16 May 2007, Bartlomiej Zolnierkiewicz wrote:
> > 
> > * host driver fixes:
> >   - pdc202xx_old: mode programming rewrite (a lot of bugs fixed)
> >   - serverworks/sis5513: PIO mode setup fixes
> >   - sl82c105: MWDMA0/1 support by Sergei
> >   - cs5530/sc1200/sl82c105: ->speedproc support ("hdparm -X")
> 
> > * 2nd part of cleanups basing on DMA tuning rework (which was merged
> >   in the previous IDE update) - quite straightforward code re-factoring
> >   (no functionality changes) and removal of no longer needed functions.
> > 
> >   This results in simpler, more generic code and in ~300 LOCs gone.
> > 
> > * some misc fixes/updates
> 
> Bartlomiej, this really was too late for the 2.6.22 merge window. I'm 
> going to pull it, since it seems borderline mostly fixes and the 

Thanks.

> refactoring should hopefully not change any functionality, but I really 

Moreover most of these patches have been in IDE tree and -mm for
over 2 months so they really should be fine.

> don't enjoy it. Please don't do this again.

OK and sorry for that.

Bart
