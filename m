Return-Path: <linux-kernel-owner+w=401wt.eu-S1764026AbXJQIMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764026AbXJQIMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 04:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbXJQIMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 04:12:19 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11802 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876AbXJQIMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 04:12:18 -0400
Date: Wed, 17 Oct 2007 10:11:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kristof Provost <Kristof@provost-engineering.be>
Cc: Jan-Simon M?ller <dl9pf@gmx.de>, linux-kernel@vger.kernel.org,
       NeilBrown <neilb@suse.de>
Subject: Re: [BUG] memory leak in dm
Message-ID: <20071017081149.GD5043@kernel.dk>
References: <20071016113800.GA4631@luggage> <20071016114458.GD5263@kernel.dk> <200710161523.47111.dl9pf@gmx.de> <20071016151207.GA4452@luggage>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016151207.GA4452@luggage>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16 2007, Kristof Provost wrote:
> On 2007-10-16 15:23:46 (+0200), Jan-Simon M?ller <dl9pf@gmx.de> wrote:
> > Am Dienstag 16 Oktober 2007 13:44:58 schrieb Jens Axboe:
> > > Please try with this patch from Neil.
> > Tried the patch. Now its usable - as far as i can say. Compiled a fresh kernel 
> > to "stress" the system (make -j3).
> > Without the patch the system had freezed after some minutes during compile.
> Same here. As far as I can tell it's fixed.

Great, thanks for testing. Current git has the fix as of last night
(CET).

-- 
Jens Axboe

