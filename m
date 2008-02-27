Return-Path: <linux-kernel-owner+w=401wt.eu-S1764572AbYB0Hyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764572AbYB0Hyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbYB0Hyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:54:37 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:41950 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754235AbYB0Hyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:54:36 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.25-rc2 + smartd = hang 
In-reply-to: <200802262054.12806.bzolnier@gmail.com> 
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <200802241654.49150.bzolnier@gmail.com> <20080226082056.7519C93C195@tippex.mynet.homeunix.org> <200802262054.12806.bzolnier@gmail.com>
Comments: In-reply-to Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
   message dated "Tue, 26 Feb 2008 20:54:12 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 27 Feb 2008 08:53:46 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080227075346.9D55D93C5CF@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JUH7U-00025u-5V.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1JUH7U-00025u-5V 96bab61aa913888200a3f842ba1184f4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bzolnier@gmail.com said:
> Thanks.
> Unfortunately nothing seems wrong with the patch... :(
> I'll take a closer look when I have some more time...
> Bart 


Just to make sure I didn't goofed up the bisection...

I bisected between v2.6.24 and v2.6.25-rc2. In the midst of the bisection, make
install decided to call the new version 2.6.24-rc7-gXXXX. Is that ok? I figured
rc7+delta was before 24-final, hence outside the bisection? After that event I
got the normal series of good god bad good... So I figured we were on the right
track anyway...

/A 

