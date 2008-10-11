Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbYJKNxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbYJKNxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 09:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYJKNxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 09:53:38 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47844 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbYJKNxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 09:53:37 -0400
Date: Sat, 11 Oct 2008 15:53:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: petkovbb@gmail.com
Cc: Robert Hancock <hancockr@shaw.ca>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] ide: locking improvements
Message-ID: <20081011135300.GP19428@kernel.dk>
References: <fa.Ke90oacfRjgiI4x5LejzjssRBEg@ifi.uio.no> <fa.8TkQ+xA96EhlNKL9gIbVTxVrcUE@ifi.uio.no> <48F010AB.7010009@shaw.ca> <200810111339.44998.bzolnier@gmail.com> <20081011120137.GA26835@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011120137.GA26835@gollum.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11 2008, Borislav Petkov wrote:
> > >From my perspective the main gain of these patches is the increased
> > maintainability and sanity of the code, scalability improvements are
> > just an added bonus.
> 
> and better code/improved scalability is a bad thing because... ?!

It's a bad thing because nobody on earth cares about IDE scalability,
from a performance POV a modern SATA controller is just better on
several levels. I don't think anybody cares about IDE scaling on 8-16
cores or more, simply because NOBODY is using IDE on such systems.

As such, trying to improve locking is a pointless exercise. And that is
a bad thing, because code change invariably brings in code bugs. Then
see previous mail on lack of coverage testing, and it can naturally be
harmful.

> > > rather like putting makeup on a corpse to me..
> 
> so _NOT_ true.

Depends on what you think is the corpse. Since IDE is essentially dead
and frozen, it IS a corpse and the phrase is then very appropriate. This
is not a personal jab at the IDE guys and does not reflect on the
(mostly) good work they do, just a reflection on the state of IDE in
general.

-- 
Jens Axboe

