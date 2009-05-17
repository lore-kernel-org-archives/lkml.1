Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbZEQPUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbZEQPUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 11:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbZEQPUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 11:20:25 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:38278 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZEQPUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 11:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=IH9Q9fjE/lSxSPph7IM8sDjrSMoaSxlzrebv0lNIyu8FoPeHktsgGogt3s19xSbKuD
         59FzZQmMBy48u2CGlTKIAkVSTxNf8ySH67wXNBk9La6+sMjNILI+77m4sngMOt74Vj1k
         /RTMiTohGW4xn5eqvYlG0utV9UmhZ0ObJSQUo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 0/15 v2] ide-atapi: remove pc->buf and misc cleanups
Date: Sun, 17 May 2009 15:12:49 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <1242364293-29223-1-git-send-email-petkovbb@gmail.com> <200905162135.53084.bzolnier@gmail.com> <20090517103343.GB27838@liondog.tnic>
In-Reply-To: <20090517103343.GB27838@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905171512.50019.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 May 2009 12:33:43 Borislav Petkov wrote:
> Hi,
> 
> On Sat, May 16, 2009 at 09:35:52PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> [..]
> 
> > > > Looking at creation dates I suspect that somewhere along the way
> > > > something was rebased?
> > > > 
> > > > One quick temporary solution would be to recreate bp/pc-remove-buf
> > > > on top of tj/block-peek-fetch...
> > > 
> > > will do that first thing in the morning and push it for merging.
> > 
> > Cool, please also merge ide-tape DEBUG build fix while at it...
> 
> I'd suggest we merge that one before 2.6.30 hits the stores :) since it
> is trivial enough and I won't have to backport it. Here's a rediffed
> version against your for-next branch:
> 
> --
> 
> From: Mark de Wever <koraq@xs4all.nl>
> Date: Sun, 17 May 2009 12:29:28 +0200
> Subject: [PATCH] ide-tape: fix debug call
> 
> This error only occurs when IDETAPE_DEBUG_LOG is enabled.
> 
> Signed-off-by: Mark de Wever <koraq@xs4all.nl>
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
