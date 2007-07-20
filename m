Return-Path: <linux-kernel-owner+w=401wt.eu-S1760060AbXGTF5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060AbXGTF5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 01:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXGTF5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 01:57:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:35598 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbXGTF5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 01:57:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BGT/T7WmzZHWZ3ew1Ndnfvts7fn2ynzYgtSEvG+QVNScSAu24S9il08zDamdwH8Sg9WU9mlzaj6g8oRG92v5yO1FLzhC8AyCs941RYyfP83osbcPah3ckAya4OCEN46k5JwsFEleVnn0DqOzlVnH1EyvmytSxDsVZXtaP5sM0rU=
Message-ID: <a8e1da0707192257n15bfb32fh64913b9cf73f3ddf@mail.gmail.com>
Date: Fri, 20 Jul 2007 05:57:00 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Al Boldi" <a1426z@gawab.com>
Subject: Re: [RFH] Partion table recovery
Cc: linux-raid@vger.kernel.org, "Willy Tarreau" <w@1wt.eu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <a8e1da0707192220x264d6675ie739b12f7ce81453@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707200813.03553.a1426z@gawab.com>
	 <a8e1da0707192220x264d6675ie739b12f7ce81453@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Dave Young <hidave.darkstar@gmail.com> wrote:
> >On 7/20/07, Al Boldi <a1426z@gawab.com> wrote:
> > As always, a good friend of mine managed to scratch my partion table by
> > cat'ing /dev/full into /dev/sda.  I was able to push him out of the way, but
> /dev/null ?
withdraw my wrong comment.

> > at least the first 100MB are gone.  I can probably live without the first
> > partion, but there are many partitions after that, which I hope should
> > easily be recoverable.
> >
> > I tried parted, but it's not working out for me.  Does anybody know of a
> > simple partition recovery tool, that would just scan the disk for lost
> > partions?
> >
> The best way is to backup you partition table before destroyed.
>

And another method is use loop device with the offset option.

Regards
dave
