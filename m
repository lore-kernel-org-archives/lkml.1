Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbZI1IGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbZI1IGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 04:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZI1IGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 04:06:54 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39248 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbZI1IGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 04:06:53 -0400
Date: Mon, 28 Sep 2009 09:07:29 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/checksum.c: Fix another endianess bug
Message-ID: <20090928080729.GB6793@console-pimps.org>
References: <1253888440-14111-1-git-send-email-matt@console-pimps.org> <8bd0f97a0909251000y3316891dh4d09744ed98139e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0909251000y3316891dh4d09744ed98139e8@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 01:00:25PM -0400, Mike Frysinger wrote:
> On Fri, Sep 25, 2009 at 10:20, Matt Fleming wrote:
> > From: Matt Fleming <matthew.fleming@imgtec.com>
> >
> > This fix allows the generic checksum code to work on my little endian
> > system. The previous fix was not enough, as "buff" is a big-endian
> > value. Without this patch I see malformed TCP packets.
> 
> can you try this one ?
> http://lkml.org/lkml/2009/6/23/597
> -mike

Yep, that one works fine also. Thanks, Mike. Who's going to pick this
up? I'm guessing this commit is also applicable for stable? Though, I
don't know if there are any little-endian users of this code in stable.
