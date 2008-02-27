Return-Path: <linux-kernel-owner+w=401wt.eu-S1762372AbYB0WSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762372AbYB0WSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761593AbYB0WST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:18:19 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:42912 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760214AbYB0WSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:18:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=uaOHRwKaduaPr54jodli9Xcq1cJTX5XHbEnRb1dGnfZ31btqfQ5rZGWiaylMrUmvNSVCDcbt83Y7De2RdfnZHrJRb4K3rGojudkz0AOOkXQvfnyrwXlh59xkOEER+7YGaaBPyzrsPytUx5SsTpLWrREAEy6pevV0+xRZG6XJtKA=
Date: Wed, 27 Feb 2008 23:18:14 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/5] ide-cd: trivial fixes
Message-ID: <20080227221814.GC9545@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1204136449-9490-1-git-send-email-petkovbb@gmail.com> <200802272218.40312.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802272218.40312.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 10:18:40PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Wednesday 27 February 2008, Borislav Petkov wrote:
> > Hi Bart,
> > 
> > here are the ide-cd trivial fixes split in an easier to digest format. I
> > cannot do the md5sum check here since all of the patches change at least one
> > char but i hope that this'll be redundant here since they're trivially easy
> > to review :) now.
> > 
> >  drivers/ide/ide-cd.c |  591 +++++++++++++++++++++++++-------------------------
> >  1 files changed, 298 insertions(+), 293 deletions(-)
> 
> applied everything
> 
> BTW patch #3/5 which accounts for 2/3 of the diffstat passes md5sum check here

huh, are you sure? The fixup-comments patch adds at least one char to the source
file so the md5sums cannot be the same.

-- 
Regards/Gruﬂ,
    Boris.
