Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab0CEPkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:40:49 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53157 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752506Ab0CEPks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:40:48 -0500
Date: Fri, 5 Mar 2010 15:42:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: daniel@fooishbar.org, skeggsb@gmail.com, airlied@linux.ie,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       dri-devel@lists.sf.net, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [git pull] drm request 3
Message-ID: <20100305154201.4885c9c2@lxorguk.ukuu.org.uk>
In-Reply-To: <20100305.072612.186421758.davem@davemloft.net>
References: <20100305123834.0d9c6277@lxorguk.ukuu.org.uk>
	<20100305.063718.211238119.davem@davemloft.net>
	<20100305151754.GB2505@tempa>
	<20100305.072612.186421758.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Personally I wouldn't have ever committed to that "user visible APIs
> can break cause it's in -stable."  Because that's complete garbage

Staging has to have the no API rules. Read some of the stuff in there to
understand why or apply about 30 seconds of thought to what it would mean
to you.

There are staging drivers using old wireless layers. If you say that no
API can be broken from staging then you will have to put the old wireless
compatibility into your network code forever. Does that fill you with
joy, light and happiness ?

Whether nouveau should ever have gone into staging is a different
question.

I don't personally think its all as clear cut as it might seem. Quite a
few distributions ship whacky wireless drivers with old API's as the
choice is that or nothing. They manage the user expectation and they deal
with the drivers moving from one wireless stack to the other and
mostly successfully hide it in userspace.

The differences here appear to be
- Having no video is more annoying than having no wireless
- Userspace failed to hide it (so maybe its not a kernel ABI problem but
  a failure to anticipate the need for versioned libdrm and the
  importance in some eyes of supporting the kernel.org kernel - which
  like it or not is a corner case for distro *users*).
- The box it broke happened to belong to Linus

but that doesn't really require tantrums or fingerpointing to fix,
particularly when its only the combination of a set of decisions and
misunderstandings by Linus, Fedora and the Nouveau developers together
that combined to create the mess.

Alan


