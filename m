Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbZIVGpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbZIVGpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 02:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZIVGp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 02:45:29 -0400
Received: from ozlabs.org ([203.10.76.45]:39791 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbZIVGp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 02:45:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [PATCH] fix BUILD_BUG_ON() and a couple of bogus uses of it
Date: Tue, 22 Sep 2009 16:15:30 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Ben Elliston <bje@air.net.au>
References: <4A8AEBFD0200007800010580@vpn.id2.novell.com>
In-Reply-To: <4A8AEBFD0200007800010580@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909221615.31334.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 01:29:25 am Jan Beulich wrote:
> Note that in the gfp.h, kmemcheck.h, and virtio_config.h cases
> MAYBE_BUILD_BUG_ON() really just serves documentation purposes - even
> if the expression is compile time constant (__builtin_constant_p()
> yields true), the array is still deemed of variable length by gcc, and
> hence the whole expression doesn't have the intended effect.

How annoying.  A gcc build assert extension would be great here?

Thanks,
Rusty.
