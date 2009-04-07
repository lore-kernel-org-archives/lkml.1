Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZDGLoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZDGLoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 07:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZDGLoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 07:44:30 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:62692 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZDGLoa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 07:44:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XPPWfdQyOktMRaZRO7C/XeBkIuUuNIBFH0T/ZYrqeXw6ZPrumhMnLyS9qjP7+KGzWm
         LD4hI2t32qr+GbsJnme4atUcQwJWlJ+fHZzr/GZ9qbMg28oU57RZ+FWNSP+bYbIjnHdD
         tTqaWDgk+UfUXQDuXl35ivSgFFmpYQvvY0hg4=
MIME-Version: 1.0
In-Reply-To: <20090407113909.GS5178@kernel.dk>
References: <20090407113909.GS5178@kernel.dk>
Date: Tue, 7 Apr 2009 15:44:28 +0400
Message-ID: <a4423d670904070444p75bb8811p779ca9ed12719df4@mail.gmail.com>
Subject: Re: [GIT PULL] block updates for 2.6.30-rc1
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, gentuu@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/7 Jens Axboe <jens.axboe@oracle.com>:
> Hi Linus,
>
> This is the collected set of small updates in the block area, as well as
> the CFQ update you tested yesterday. It's essentially the same, but
> allows for a bit more queuing for a solitary IO issuer. If it ends up
> interferring too much with new IO, I'll augment that check with a time
> based one as well. Looks good here, though.
>
> There's also a fix for a long standing CFQ problem that caused slowdowns
> with CFQ on streamed IO due to CFQ being too eager to restart IO
> queuing.
>
>  git://git.kernel.dk/linux-2.6-block.git for-linus
>

Hi Jens

I sent you a fix for loop device.
http://patchwork.kernel.org/patch/15763/
