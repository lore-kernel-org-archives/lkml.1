Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbXHTWt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbXHTWt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXHTWtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:49:16 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:56170 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbXHTWtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:49:15 -0400
Date: Tue, 21 Aug 2007 07:47:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 1/1] ensure we don't use bootconsoles after init has been released
Message-ID: <20070820224759.GA9360@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org,
	Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>
References: <200708192246.05783.rgetz@blackfin.uclinux.org> <8bd0f97a0708192011m1b957e57je313850a255dcac7@mail.gmail.com> <20070820033143.GA4918@linux-sh.org> <200708201522.47591.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708201522.47591.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 03:22:47PM -0400, Robin Getz wrote:
> Try #4... (sorry)
>  
> From: Robin Getz <rgetz@blackfin.uclinux.org>
>  
> This is a followup to the cleanups for earlyprintk patch from Gerd Hoffmann
>  
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69331af79cf29e26d1231152a172a1a10c2df511
>  
> This ensures that a bootconsole is unregistered if it is not replaced.
> The current implementation spews garbage out the bootconsole in this case,
> since the bootconsole structure is normally in the init section, and is
> freed, but still used.
>  
> Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
> CC: Gerd Hoffmann <kraxel@redhat.com>
> CC: Paul Mundt <lethal@linux-sh.org>
> CC: Mike Frysinger <vapier.adi@gmail.com>

Looks better, thanks.

Acked-by: Paul Mundt <lethal@linux-sh.org>
