Return-Path: <linux-kernel-owner+w=401wt.eu-S1759114AbYB0Wrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114AbYB0Wrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbYB0WrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:47:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:44339 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbYB0WrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:47:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=fSxFrWCkQrNndeJKzAvg0FumLvjXfTg5kzEx+H75c7a2cJpCfah8sCVYf+eloNcQbYQDxE1ff/pmUsqpOC4IyqA2n3S710VxxPIau0EI0NOcq1Dirayc8Q5dWT5z4UVykf6RVUgG5qhVrPT88aU8j7Hin9W7vo+EXeLzCxw5Tv0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 0/5] ide-cd: trivial fixes
Date: Wed, 27 Feb 2008 23:48:34 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1204136449-9490-1-git-send-email-petkovbb@gmail.com> <200802272218.40312.bzolnier@gmail.com> <20080227221814.GC9545@gollum.tnic>
In-Reply-To: <20080227221814.GC9545@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200802272348.35011.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2008, Borislav Petkov wrote:
> On Wed, Feb 27, 2008 at 10:18:40PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > On Wednesday 27 February 2008, Borislav Petkov wrote:
> > > Hi Bart,
> > > 
> > > here are the ide-cd trivial fixes split in an easier to digest format. I
> > > cannot do the md5sum check here since all of the patches change at least one
> > > char but i hope that this'll be redundant here since they're trivially easy
> > > to review :) now.
> > > 
> > >  drivers/ide/ide-cd.c |  591 +++++++++++++++++++++++++-------------------------
> > >  1 files changed, 298 insertions(+), 293 deletions(-)
> > 
> > applied everything
> > 
> > BTW patch #3/5 which accounts for 2/3 of the diffstat passes md5sum check here
> 
> huh, are you sure? The fixup-comments patch adds at least one char to the source
> file so the md5sums cannot be the same.

OTOH md5sums of the resulting _binary_ files matches... ;-) 
