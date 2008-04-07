Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbYDGUMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbYDGUMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYDGUMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:12:03 -0400
Received: from ozlabs.org ([203.10.76.45]:51203 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbYDGUMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:12:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio: remove overzealous BUG_ON.
Date: Tue, 8 Apr 2008 06:09:12 +1000
User-Agent: KMail/1.9.9
Cc: Anthony Liguori <anthony@codemonkey.ws>, virtualization@lists.osdl.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200804071430.28399.rusty__35361.6672721275$1207542780$gmane$org@rustcorp.com.au> <47FA26A0.3020701@codemonkey.ws>
In-Reply-To: <47FA26A0.3020701@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804080609.12891.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 April 2008 23:50:24 Anthony Liguori wrote:
> Rusty Russell wrote:
> > The 'disable_cb' callback is designed as an optimization to tell the host
> > we don't need callbacks now.  As it is not reliable, the debug check is
> > overzealous: it can happen on two CPUs at the same time.  Document this.
> >
> > Even if it were reliable, the virtio_net driver doesn't disable
> > callbacks on transmit so the START_USE/END_USE debugging reentrance
> > protection can be easily tripped even on UP.
> >
> > Thanks to Balaji Rao for the bug report and testing.
>
> I think the printk() in start_xmit should be removed too (or at least
> rate limited).

Yep, please send patch.  I'm about to jump on a plane, so consider this a 
pre-canned ack.

Thanks,
Rusty.
