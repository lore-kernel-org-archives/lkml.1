Return-Path: <linux-kernel-owner+w=401wt.eu-S965964AbXIBMCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965964AbXIBMCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964904AbXIBMBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:01:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:55931 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964899AbXIBMBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k6CFgb0co18OW4LU7jTdUEpuCC1YxAThCjdi2KNTrUHQo+dERDTsvOrltP9K4zaxpTS0eQ6FwHjeQ/P0XYOqFpXh6LBj1nwTKqR0NgEI2e3PhxTAoV5pZ0qHaAZY0rrQp+Yae0bUn9WiboiFnjSq5NlKqnYEcdS6RS9HexWfdTc=
Message-ID: <6bffcb0e0709020501j9abf9c4mbf970a90291b9522@mail.gmail.com>
Date: Sun, 2 Sep 2007 14:01:49 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Master volume control broken (regression against 2.6.22)
Cc: "Thomas Meyer" <thomas@m3y3r.de>, linux-kernel@vger.kernel.org,
       contact@i-nz.net, "Jaroslav Kysela" <perex@suse.cz>,
       "Takashi Iwai" <tiwai@suse.de>
In-Reply-To: <20070902045432.18668762.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46C6CAFC.1020709@m3y3r.de>
	 <20070902045432.18668762.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 02/09/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Sat, 18 Aug 2007 12:33:32 +0200 Thomas Meyer <thomas@m3y3r.de> wrote:
> > This commit broke my master volume control:
> >
> > 5d5d3bc3eddf2ad97b2cb090b92580e7fed6cee1 is first bad commit
> > commit 5d5d3bc3eddf2ad97b2cb090b92580e7fed6cee1
> > Author: Ivan N. Zlatev <contact@i-nz.net>
> > Date:   Tue May 29 16:03:00 2007 +0200
> >
> >     [ALSA] hda-codec - Fix pin configs for Intel Macs
> >
> >     * adds the pinconfigs for all 5 Apple boards and 14 Subsystem IDs
> >       (support for possibly all iMac, Mac, MacMini etc etc)
> >     * adds 'intel-mac-v1' to v5 models which replace the current
> >     * reflects changes in Alsa-Configuration.txt
> >
> >     Signed-off-by: Ivan N. Zlatev <contact@i-nz.net>
> >     Signed-off-by: Takashi Iwai <tiwai@suse.de>
> >     Signed-off-by: Jaroslav Kysela <perex@suse.cz>
> >
> > :040000 040000 16c8f8d66545ab0cb6dfc44f3c92ff9ad0b53658
> > e3e9a07b1a3a0d68c6870f7a111ca817a89ce24b M      Documentation
> > :040000 040000 b49d5f64d27e248f08d6fad8b1ff4f03c182f46a
> > b4a361b5cacc96d139572b592bbcba3504c1f9c5 M      sound
> >
> > I no longer can use my fancy multimedia control keys :-(
> >
>
> You mean that 2.6.22 works OK and 2.6.23-rcX does not?
>

It was on KR list, but Takashi has said that this is a feature not regression.

http://lkml.org/lkml/2007/8/29/128

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
