Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbYJKOsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbYJKOsL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 10:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbYJKOr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 10:47:57 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:27182 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbYJKOr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 10:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=XgTkhm7lATA9LCvIf0mpxcS7CUxxKW45Vk9jlxpR+1MpBWzYYiyZB5wgYalasHFv7W
         coNNGGbdZW46LU/5SyGVCR9bdRMMXSq6PoQ4AEeTexYGdPLgB73noUH8qgTCemIsxX47
         NdygzDHfLxLOSSLcfZNSo9+H7ggaRekioZd+I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/7] ide: locking improvements
Date: Sat, 11 Oct 2008 16:45:27 +0200
User-Agent: KMail/1.9.10
Cc: petkovbb@gmail.com, Robert Hancock <hancockr@shaw.ca>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <fa.Ke90oacfRjgiI4x5LejzjssRBEg@ifi.uio.no> <20081011120137.GA26835@gollum.tnic> <20081011135300.GP19428@kernel.dk>
In-Reply-To: <20081011135300.GP19428@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810111645.27847.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 October 2008, Jens Axboe wrote:
> On Sat, Oct 11 2008, Borislav Petkov wrote:
> > > >From my perspective the main gain of these patches is the increased
> > > maintainability and sanity of the code, scalability improvements are
> > > just an added bonus.
> > 
> > and better code/improved scalability is a bad thing because... ?!
> 
> It's a bad thing because nobody on earth cares about IDE scalability,

JFYI: just yesterday I got mail proving otherwise. ;)

> from a performance POV a modern SATA controller is just better on
> several levels. I don't think anybody cares about IDE scaling on 8-16
> cores or more, simply because NOBODY is using IDE on such systems.
> 
> As such, trying to improve locking is a pointless exercise. And that is
> a bad thing, because code change invariably brings in code bugs. Then
> see previous mail on lack of coverage testing, and it can naturally be
> harmful.

Your concerns were already addressed in my reply but I worry that having
a discussion based on technical arguments is not your goal.

Just to repeat: these patches are not hardware specific and obviously
they are not going to be merged today, tomorrow or in a week (they are
2.6.29 material after months of time in pata tree / linux-next).

> > > > rather like putting makeup on a corpse to me..
> > 
> > so _NOT_ true.
> 
> Depends on what you think is the corpse. Since IDE is essentially dead
> and frozen, it IS a corpse and the phrase is then very appropriate. This
> is not a personal jab at the IDE guys and does not reflect on the
> (mostly) good work they do, just a reflection on the state of IDE in
> general.

Interesting statement given that i.e. diffstat-wise pata tree has more
than twice as much stuff queued up for 2.6.28 than "some other" trees
(and we have history of being a _very_ conservative w.r.t. to needlessly
moving code around in drivers/ide/).

Please stop being silly and pushing your view/idea on what other people
should be doing (not to mention ignoring real facts).

Thanks,
Bart
