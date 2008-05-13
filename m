Return-Path: <linux-kernel-owner+w=401wt.eu-S1759901AbYEMM7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901AbYEMM7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYEMM7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:59:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:46170 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYEMM7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:59:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f/YdLk7pKw4m6+KNS7/0JVNJ9Yj8LY3lVvcXTJYfyD0Wfrs36IN5z6uygSrj7naNGwAp7vnQFLu6r9+/WQOJ3la9x4Icq7axJ2rYrBKVjFbjYoYH65n5Knu/nDRSnAyCaErH1gAvWFYU5iJ7MzcVHvSm4xchSpQGe6Zxdh1LIDI=
Message-ID: <e85b9d30805130558l502addbcq21996b92fdbfdc5b@mail.gmail.com>
Date: Tue, 13 May 2008 14:58:53 +0200
From: Matthew <jackdachef@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Cc: "Kasper Sandberg" <lkml@metanurb.dk>,
       "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080513122021.GP16217@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220805110614i7160a8a5o36d55acb732c1b59@mail.gmail.com>
	 <1210514567.7827.62.camel@localhost>
	 <20080513122021.GP16217@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 2:20 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>
> On Sun, May 11 2008, Kasper Sandberg wrote:
>  > On Sun, 2008-05-11 at 14:14 +0100, Daniel J Blueman wrote:
>  > > I've been experiencing this for a while also; an almost 50% regression
>  > > is seen for single-process reads (ie sync) if slice_idle is 1ms or
>  > > more (eg default of 8) [1], which seems phenomenal.
>  > >
>  > > Jens, is this the expected price to pay for optimal busy-spindle
>  > > scheduling, a design issue, bug or am I missing something totally?
>  > >
>  > > Thanks,
>  > >   Daniel
[snip]
...
[snip]
>  >
>  > Thisd would appear to be quite a considerable performance difference.
>
>  Indeed, that is of course a bug. The initial mail here mentions this as
>  a regression - which kernel was the last that worked ok?
>
>  If someone would send me a blktrace of such a slow run, that would be
>  nice. Basically just do a blktrace /dev/sda (or whatever device) while
>  doing the hdparm, preferably storing output files on a difference
>  device. Then send the raw sda.blktrace.* files to me. Thanks!
>
>  --
>  Jens Axboe
>
>

Hi Jens,

I called this a "regression" since I wasn't sure if this is a real bug
or just something introduced recently, I just started to use cfq as
main io-scheduler so I can't tell ...

testing 2.6.17 unfortunately is somewhat impossible for me (reiser4;
too new hardware - problems with jmicron)

google "says" that it seemingly already existed since at least 2.6.18
(Ubuntu DapperDrake) [see:
http://ubuntuforums.org/showpost.php?p=1484633&postcount=12]

well - back to topic:

for a blktrace one need to enable  CONFIG_BLK_DEV_IO_TRACE , right ?
blktrace can be obtained from your git-repo ?

Thanks

Mat
