Return-Path: <linux-kernel-owner+w=401wt.eu-S933600AbXKPVbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600AbXKPVbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbXKPVb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:31:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:6346 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbXKPVb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:31:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=P58uf+aAPrjMPtDyf4bYNSiwqhmaJdOYYD93Xw367iyCD9u2Lhsej2o09d5gwweNXSqL+RrKlGwCw4wx2cOy8XEK7xSu29qi52cDOz+9S4NBh8EzdLDZoEVuDfMHeWSQxeVoYkMLcc0V2brYmJ4RqS7H0FXWrHSqC0tjFKwDASU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jonas Stare <jonas.stare@purplescout.se>
Subject: Re: [PATCH][RESUBMIT] drivers/ide/ide-probe.c, kernel 2.6.23.1
Date: Fri, 16 Nov 2007 22:22:54 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-ide@vger.kernel.org
References: <473434F1.50509@purplescout.se> <200711152159.23607.bzolnier@gmail.com> <473D88A5.306@purplescout.se>
In-Reply-To: <473D88A5.306@purplescout.se>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711162222.54847.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 November 2007, Jonas Stare wrote:
> Resubmit of IDE-probing-patch. It now checks hwif->drives[unit].present instead of
> forced_geom and there is also an if-statement so it doesn't change back to the master
> unless it have to. I choose to put it inside the if-statement that checks the return
> code from ide_wait_not_busy, since it shouldn't revert back to the master drive unless
> something is wrong and we have to leave the function. (I also left the old SELECT_DRIVE
> after the for-loop so that we will select the master if everything is ok.) Inside the
> if-statement or not makes not big difference until you get more than two drives on the
> ide-bus...but this code should be ready for it. :)
> 
> Signed-off-by: Jonas Stare <jonas.stare@purplescout.se>

Patch looks fine (thanks for fixing it) but please replace the changelog
above with the proper patch description (more like in your first mail which
contained the description of the problem encountered and of the solution,
also please try to keep it within 80-columns limit) - for git history patch
changelog is not really that interesting/valuable.

PS patch summary ("Subject:") may also be improved while at it - it should
describe the main goal of the patch, also since patch will be applied to
the current git tree giving the kernel version is not necessary.

Bart
