Return-Path: <linux-kernel-owner+w=401wt.eu-S1763471AbXFEIHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763471AbXFEIHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 04:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbXFEIGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 04:06:47 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:54475 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbXFEIGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 04:06:45 -0400
Date: Tue, 5 Jun 2007 10:06:26 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Mike Richards <mrmikerich@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: To swap or not to swap?
In-Reply-To: <516d7fa80706042135p3d0b87fawcc94971af1f529c3@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0706051000140.20829@yvahk01.tjqt.qr>
References: <516d7fa80706042135p3d0b87fawcc94971af1f529c3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 5 2007 00:35, Mike Richards wrote:
>
> In my research on this matter I've come across various comments by
> people saying that getting rid of swap entirely will hurt performance
> somehow, but on these servers I'm  seeing very little swap used in the
> first place, so I'm not seeing how that's really possible. But to
> avoid that being an issue, let's suppose I give each server 32MB of
> swap to cover the occasional usage. Is there any reason *not* to go
> the route of minimizing swap in order to also minimize downtime?

Generally yes. You want as much swap as the base daemons/programs take up in
RAM. Any [user] program should probably be allowed to max out your physical RAM
- the daemons go to swap in the meanwhile (mostly works with idle servers). A
program that requires more memory than physically present is anyway going to
swap in and out sometime later, degrading performance to a halt, as you
describe.

> The consensus these days seems to be that since hard drives are so big
> now, go with a gig or more of swap even if you have plenty of RAM.
> However, the way I'm seeing it is this: What's the point of having a
> gig of swap if it only gets used during the worst possible time?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

	Jan
-- 
