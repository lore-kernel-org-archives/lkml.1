Return-Path: <linux-kernel-owner+w=401wt.eu-S933794AbXCUTOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794AbXCUTOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933782AbXCUTOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:14:24 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3356 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933770AbXCUTOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:14:22 -0400
Date: Wed, 21 Mar 2007 14:59:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Michael Buesch <mb@bu3sch.de>,
       bcm43xx devel <Bcm43xx-dev@lists.berlios.de>
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070321185900.GC3801@tuxdriver.com>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <1174433034.62033.16.camel@localhost> <20070320223643.d8cbc3f6.akpm@linux-foundation.org> <4601761F.4000302@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4601761F.4000302@lwfinger.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 01:14:55PM -0500, Larry Finger wrote:
> Andrew Morton wrote:
> > On Tue, 20 Mar 2007 17:23:54 -0600 Zan Lynx <zlynx@acm.org> wrote:
> > 
> >> On Mon, 2007-03-19 at 20:56 -0800, Andrew Morton wrote:
> >>> Temporarily at
> >>>
> >>>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> >>>
> >>> Will appear later at
> >>>
> >>>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
> >> First impressions:
> >> Several of the same bugs as rc3-mm*:
> >>       * Freezes immediately if I touch the wlan0 device after loading
> >>         the new Broadcom wireless driver.
> 
> The version of the ssb driver in 2.6.21-rc4-mm1 has a bug that causes a kernel oops if the bcm43xx
> chip contains a USB (dangling) core. This bug has been fixed in Michael Buesch's tree, but
> apparently not yet in Linville's wireless-dev tree. The patch is as follows:

FWIW, that patch is in my tree as of yesterday.  Presumably it should
be in the next -mm.

John
-- 
John W. Linville
linville@tuxdriver.com
