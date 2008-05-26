Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbYEZUXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbYEZUXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 16:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbYEZUXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 16:23:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150AbYEZUXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 16:23:42 -0400
Date: Mon, 26 May 2008 16:23:17 -0400
From: Alan Cox <alan@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video4linux: Push down the BKL
Message-ID: <20080526202317.GA12793@devserv.devel.redhat.com>
References: <20080522223700.2f103a14@core> <20080526135951.7989516d@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526135951.7989516d@gaivota>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 01:59:51PM -0300, Mauro Carvalho Chehab wrote:
> cx18 and ivtv (see the attached log). Also, IMO, it would be better if you
> split drivers/net/tun.c into a different changeset.

That was most definitely not intended to be in the video patches 8)

> The next step can be to add the obvious locks inside video_ioctl2_unlocked(). Like, for
> example, locking the VIDIOC_S calls, if someone is calling the corresponding
> VIDIOC_G or VIDIOC_TRY ones.

Concentrate on the dats structures not the code - its one of those oft
quoted and very true rules - "lock data not code"

I'll tidy these up later in the week as I get time and merge them against
a current linux-next tree in bits with the rework done.

Alan

