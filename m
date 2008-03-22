Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbYCVW5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbYCVW5k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 18:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbYCVW5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 18:57:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:39651 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbYCVW5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 18:57:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=a/ZPdfgJ3yTjUBlF2ApyykszJXY1lMzCNQclE/fmdGyIeZd9AkNToqks/znP/NhXw/DbKwQMnJz5EdeLEIueV2KbHMKl3dNet6IFJRSGGOBQGlf0PHxCVlBLua8Le/BzrDaaaVPpqaSzxIch2XAs1EKSQTpjl9lLPOA3BmvupBE=
Message-ID: <84144f020803221557t36502f6bo327c95705be706bf@mail.gmail.com>
Date: Sun, 23 Mar 2008 00:57:29 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [patch 07/76] NIU: Bump driver version and release date.
Cc: jesper.juhl@gmail.com, chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jmforbes@linuxtx.org, zwane@arm.linux.org.uk,
       tytso@mit.edu, rdunlap@xenotime.net, davej@redhat.com,
       chuckw@quantumlinux.com, reviews@ml.cw.f00f.org, mkrufky@linuxtv.org,
       cebbert@redhat.com, cavokz@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de
In-Reply-To: <20080321.171401.49157146.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080321224250.144333319@sous-sol.org>
	 <20080321224333.400857992@sous-sol.org>
	 <9a8748490803211710u4c5d1d67x2a5a891347e0adf6@mail.gmail.com>
	 <20080321.171401.49157146.davem@davemloft.net>
X-Google-Sender-Auth: 0508d0e68c360f75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sat, Mar 22, 2008 at 2:14 AM, David Miller <davem@davemloft.net> wrote:
>  It makes a difference for driver maintainers when users
>  report bugs and we ask them for the version printed
>  by the driver so that we know which fixes have been
>  applied.
>
>  You know, if people are going to be jerky about this,
>  I'll just include the version bump in the actual bug
>  fixes which I sometimes do anyways.
>
>  Thanks for bringing this up, it's a useful use of
>  everyone's time :-/

Uhm, Jesper was asking a relevant question and definitely not being
"jerky". As you probably know, many of us are dropping explicit driver
versions from the code for the exact reason why you're trying to patch
the stable tree now. They get out of sync real easy and the kernel
version already provides the same information so why bother.

Furthermore, I honestly don't see how your patch meets the (rather
strict) requirements of stable series either. So it would be nice if
one of the stable maintainers stepped up to say that these kind of
patches are okay to set a precedent for others as well.

                        Pekka
