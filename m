Return-Path: <linux-kernel-owner+w=401wt.eu-S1764746AbYBZUcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764746AbYBZUcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbYBZUch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:32:37 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4948 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbYBZUcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:32:36 -0500
Date: Tue, 26 Feb 2008 15:20:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Alexey Zaytsev <zaytsev.a@protei.ru>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Message-ID: <20080226202044.GE3013@tuxdriver.com>
References: <47BEAF3B.3080809@protei.ru> <200802231727.54351.mb@bu3sch.de> <f19298770802231332x79c0395fl5519e79ae75da0aa@mail.gmail.com> <200802232320.58562.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802232320.58562.mb@bu3sch.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 11:20:58PM +0100, Michael Buesch wrote:
> On Saturday 23 February 2008 22:32:46 Alexey Zaytsev wrote:

> > And you knew that the new driver did no work with the bcm4311
> > chips, which is the sad thing.
> 
> That is not true. It doesn't work with exactly _one_ revision
> of the bcm4311 card. And that is already fixed in 2.6.25.
> I'd like to have that in .24-stable, too, but I guess it's too big.
> It changes some parts of the DMA engine code.

Which patch is it?  Is it this one?  Or is there another one that touches 4311?

commit 013978b688d2a27af3ab55ca739e8c8ac7254870
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Mon Nov 26 10:29:47 2007 -0600

    b43: Changes to enable BCM4311 rev 02 with wireless core revision 13

    The BCM94311MCG rev 02 chip has an 802.11 core with revision 13 and
    has not been supported until now. The changes include the following:

<snip>

If so, perhaps we should just consider applying this to -stable?

I really do wish everyone would tone down their rhetoric on this
issue...

John
-- 
John W. Linville
linville@tuxdriver.com
