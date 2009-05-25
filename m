Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbZEYXPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbZEYXPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbZEYXPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:15:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33775 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755385AbZEYXPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:15:42 -0400
Date: Tue, 26 May 2009 00:16:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Jacob <fun2program8@yahoo.com>,
       Christopher Hogan <chris.c.hogan@gmail.com>,
       Robert Hancock <hancockrwd@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] libata: add warning about possible HPA compatibility
 issue
Message-ID: <20090526001612.52cd484e@lxorguk.ukuu.org.uk>
In-Reply-To: <200905260115.00794.bzolnier@gmail.com>
References: <200905252348.08970.bzolnier@gmail.com>
	<200905260036.17718.bzolnier@gmail.com>
	<20090525233814.4cb8b1c2@lxorguk.ukuu.org.uk>
	<200905260115.00794.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Tejun has a patch in the queue which exposes the HPA and real sizes to
> > the OS
> 
> In queue for 2.6.30?

2.6.30 merge window is closed, as you well kow

> I fully agree w.r.t to proper handling of HPA but we need "something" in
> the meantime because it is *real* issue resulting in *real* users filling
> *real* bug-reports (which unfortunately always get assigned to me first
> so I'm needlessly wasting my time on them).

The merge window is closed. This is a 2.6.31 discussion and randomly
adding bogus printks to the kernel won't help because

- Users have no idea what they mean
- Distros boot with "quiet" so users don't see them anyway

It would be good to get Tejun's patch upstream and also runtime HPA
switching.

> IOW Please stop downplaying bug #13365 which this patch tries to alleviate.

I'm still not convinced 13365 is an HPA problem entirely - but there are
certainly other HPA confusions here and there.

> I'm adding Andrew to cc:...

Hello Andrew ;)

Alan
