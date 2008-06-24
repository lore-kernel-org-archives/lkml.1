Return-Path: <linux-kernel-owner+w=401wt.eu-S1759092AbYFXLFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092AbYFXLFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYFXLE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:04:59 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:60614 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbYFXLE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:04:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=SylxU21Cf4Y/OR/LPWzSL1IL0E2ioOJ3HFHfx/IeasoatjDX+Kdm9d91iDo23Yepco
         YNd1j33/ebJi4P6aPJFPfLcIzu7dgS36ASDO0vdvqDO81Gbn5mOqEjgAYcY8HqTk3YeC
         lZtnBNybvy0SaZyOKziw/LMq98AVn/PfupMnE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
Date: Tue, 24 Jun 2008 13:06:41 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
References: <87k5gmz596.fsf@denkblock.local> <200806240041.42796.bzolnier@gmail.com> <87skv3s3d9.fsf@denkblock.local>
In-Reply-To: <87skv3s3d9.fsf@denkblock.local>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806241306.42054.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008, Elias Oltmanns wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

[...]

> > BTW Your fix adds framework which can be re-used for fixing locking of
> >IDE
> > settings (+ it finally makes sense to dust-off my IDE settings rework which
> > was always low-prio and was never posted :) and maybe it could be also used
> > for drive->special handling.
> 
> Alan's remark made me think again and I'm still not quite sure whether I
> can (and indeed should) fix ide_abort() and allow for out of band

[...]

I don't see a reliable way to fix ide_abort() - once the request/command
is started hardware can be already in a state that makes aborting hard if
not impossible.

Thanks,
Bart
