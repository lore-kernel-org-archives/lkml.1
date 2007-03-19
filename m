Return-Path: <linux-kernel-owner+w=401wt.eu-S965400AbXCSWvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965400AbXCSWvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 18:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965370AbXCSWvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 18:51:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50262
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965400AbXCSWvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 18:51:40 -0400
Date: Mon, 19 Mar 2007 15:51:40 -0700 (PDT)
Message-Id: <20070319.155140.112852331.davem@davemloft.net>
To: chrisw@sous-sol.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       jmforbes@linuxtx.org, zwane@arm.linux.org.uk, tytso@mit.edu,
       rdunlap@xenotime.net, davej@redhat.com, chuckw@quantumlinux.com,
       reviews@ml.cw.f00f.org, mkrufky@linuxtv.org, cebbert@redhat.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de
Subject: Re: [patch 03/31] Fix user copy length in ipv6_sockglue.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070319220125.GD10574@sequoia.sous-sol.org>
References: <20070319213047.710101653@mini.kroah.org>
	<20070319213729.GE9261@kroah.com>
	<20070319220125.GD10574@sequoia.sous-sol.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>
Date: Mon, 19 Mar 2007 15:01:25 -0700

> * Greg KH (gregkh@suse.de) wrote:
> > From: Chris Wright <chrisw@sous-sol.org>
> > 
> > [IPV6] fix ipv6_getsockopt_sticky copy_to_user leak
> > 
> > User supplied len < 0 can cause leak of kernel memory.
> > Use unsigned compare instead.
> 
> You can drop this one.  It's dependent on a patch
> that is not in 2.6.20.

That's correct, it can be dropped.
