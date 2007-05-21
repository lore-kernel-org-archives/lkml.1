Return-Path: <linux-kernel-owner+w=401wt.eu-S1764926AbXEUROj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764926AbXEUROj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758523AbXEURO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:14:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:63397 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764041AbXEURO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:14:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jp/+ItQSPnhvdXAr8yaZQM3/EWNhMaV0bFblSztLgRDn2FxDJhA5Qb6YRSENWyFdOB8mWaPP1N/oIogfCquZWYQ6iClKuEi/Wax8OKK2IS0P4I2Ikf7IS8fXHVSrcUH5PlsxSn7187+g9zunj3/lFt3CmiJ8S3MzcWAZUDm2a1U=
Message-ID: <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
Date: Mon, 21 May 2007 18:14:23 +0100
From: "Dave Airlie" <airlied@gmail.com>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
	 <200705210914.22663.jbarnes@virtuousgeek.org>
	 <200705210934.58559.jbarnes@virtuousgeek.org>
	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> 1) Be upwards compatible with the existing fbdev drivers. This lets us
> avoid rewriting the 90 existing drivers. New drivers shouldn't break
> any old apps.
>

done.

> 2) Address the long outstanding issue of multi-seat at the console
> level. My solution to this is the one device per CRTC model.

done.

>
> 3) Eliminate the need for a root priv controlling process. Get rid of
> the potential for a security hole.

Stupid idea, we need something to control policy, this isn't going in
the kernel, it can be a lot smaller than X and auditable.. sticking
the DRI protocol in the kernel is just pointless..

> 4) OOPS should always display even if in a graphics mode

possible to do.

>
> 5) Support Secure Attention Key (SAK).

possible to do.

> 6) Eliminate the existing VT swap driver free for all. I would compile
> out the VT layer and replace it with a compatible API that enforces
> some sanity.

I'm hoping to look into this but it is a parallel problem to what this
code does, the VT switch API sucks rocks, so providing something
compatible is going to suck rocks..

> 7) Support Unicode on the console

This just needs a userspace console again a parallel problem that
really isn't much to do with the problem set this work is trying to
solve... it should enable it...

>
> 8) Allow multiple user space graphics systems to run. These user space
> systems should not touch the hardware, instead they ask the kernel
> driver to manipulate the hardware on their behalf. Of course the
> kernel driver is only the minimum code needed to arbitrate control of
> the resources - it doesn't do things like implement drawing
> algorithms.

No problems.

>
> 9) Booting on non-VGA hardware still needs to work.
>
> 10) Support things like cloning and output device selection.
>
No problems.

Dave.
