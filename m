Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZEKPYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZEKPYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZEKPYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:24:02 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52493 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbZEKPYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:24:01 -0400
To: jens.axboe@oracle.com
CC: miklos@szeredi.hu, max@duempel.org, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20090511121247.GZ4694@kernel.dk> (message from Jens Axboe on
	Mon, 11 May 2009 14:12:47 +0200)
Subject: Re: [patch 0/3] make splice more generic
References: <20090507133734.450612199@szeredi.hu> <20090511121247.GZ4694@kernel.dk>
Message-Id: <E1M3XKv-0001Su-Ds@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 11 May 2009 17:22:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Jens Axboe wrote:
> I have applied all three, thanks! However, I think we should be able to
> pass in whether or not this is a strict splice or not. Falling back to
> readv/writev is a good thing as it may help get the interface adopted
> more widely, but I can also easily imagine cases where you'd want to
> make sure that splice actually works without copies. It may even just be
> for users to retry with alternative code paths, instead of proceeding
> with the splice. SPLICE_F_MOVE is a soft flag in that it will move if it
> can, but not fail if it can't. Perhaps we should add a flag that does
> pass back an error if we can't just move pages around, SPLICE_F_STRICT
> or something like that.

Okay, seems pretty trivial.  I'll do a patch.

Thanks,
Miklos
