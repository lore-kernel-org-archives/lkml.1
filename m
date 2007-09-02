Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbXIBWdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbXIBWdi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 18:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbXIBWdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 18:33:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:3069 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbXIBWda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 18:33:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aCyRLZIdz7g2El1wlNAj9oupvyxEA7Rz1IVHJWpF+IarL+cJ0MH3YDqIAx3+mu1x/KvM3FHEIpxgpOrM+FyQXny02DQESlb1gQ3asxQWp8wMlaOgfjrh0nKPA1dYjOMGaH62dxrH397k7cxBP9ifT1+G3eBZ4lAIx5VNyon5VbU=
Message-ID: <6bffcb0e0709021533u1fd81db6pfb0d985d80f73995@mail.gmail.com>
Date: Mon, 3 Sep 2007 00:33:28 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: [4/4] 2.6.23-rc4: known regressions
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Pavel Machek" <pavel@ucw.cz>,
       "Arkadiusz Miskiewicz" <arekm@maven.pl>
In-Reply-To: <1188470552.22467.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46D58CC6.4020605@googlemail.com> <46D59073.4010101@googlemail.com>
	 <1188470552.22467.8.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 30/08/07, Soeren Sonnenburg <kernel@nn7.de> wrote:
> On Wed, 2007-08-29 at 17:27 +0200, Michal Piotrowski wrote:
>
> > Power management
> >
> > Subject         : something broke resume from s2ram on mbp c1d (??? :))
> > References      : http://lkml.org/lkml/2007/8/28/67
> > Last known good : 2.6.23-rc3
> > Submitter       : Soeren Sonnenburg <kernel@nn7.de>
> > Caused-By       : ?
> > Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> > Status          : unknown
>
> > Subject         : resume from ram much slower
> > References      : http://lkml.org/lkml/2007/8/10/275
> > Last known good : 2.6.23-rc1 ?
> > Submitter       : Arkadiusz Miskiewicz <arekm@maven.pl>
> > Caused-By       : ?
> > Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> > Status          : problem is being debugged
>
>
> I am not sure whether the problem I am having is not the very same as
> the one Arkadiusz is seeing. At least I've found resume from s2ram to be
> working a couple of times. Only sometimes it took long to resume, that
> is >30 seconds (around 5 - which I already consider long - is normal).
>
> anyway this this is with the closed source fglrx kernel module,

Arkadiusz, are you using any of these binary crap modules?

> as
> without the machine freezes when X is running on resume...
>
> well and fglrx seems to cause this ...
>
> BUG: scheduling while atomic: Xorg/0x00000002/3408
>  [<c03c39a2>] schedule+0x5d2/0x6d0
>  [<c0127038>] __wake_up+0x38/0x50
>  [<f8c2df71>] irqmgr_wrap_shutdown+0xe1/0x150 [fglrx]
>  [<f8c1b42f>] firegl_release_helper+0x55f/0x7d0 [fglrx]
>  [<f8c1ed8b>] firegl_takedown+0x5b/0xc40 [fglrx]
>  [<f8c1e41f>] firegl_release+0x12f/0x190 [fglrx]
>  [<f8c126ff>] ip_firegl_release+0xf/0x20 [fglrx]
>  [<c017a451>] __fput+0x91/0x160
>  [<c01776f9>] filp_close+0x49/0x80
>  [<c012f56c>] put_files_struct+0x9c/0xc0
>  [<c013080e>] do_exit+0x12e/0x7c0
>  [<f8c6dd09>] IRQMGR_WorkerThreadRoutine+0x29/0x30 [fglrx]
>  [<f8c0fb90>] kasThreadRoutineHelper+0x0/0x20 [fglrx]
>  [<f8c0fb90>] kasThreadRoutineHelper+0x0/0x20 [fglrx]
>  [<f8c2dd1e>] IRQMGR_CallbackWrapper+0xe/0x20 [fglrx]
>  [<f8c0fb90>] kasThreadRoutineHelper+0x0/0x20 [fglrx]
>  [<c0104f85>] kernel_thread_helper+0xd/0x18
>
> well...
> Soeren

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
