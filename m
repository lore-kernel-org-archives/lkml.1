Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbXFTLdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbXFTLdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 07:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXFTLdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 07:33:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46816 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbXFTLdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 07:33:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mattia Dongili <malattia@linux.it>
Subject: Re: can't suspend on vaio sz (rc4 and rc5 are ok) [was Re: 2.6.22-rc4-mm2]
Date: Wed, 20 Jun 2007 13:40:18 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070620052222.GA4452@inferi.kami.home>
In-Reply-To: <20070620052222.GA4452@inferi.kami.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706201340.19404.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 June 2007 07:22, Mattia Dongili wrote:
> On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
> 
> Hello,
> on this vaio sz72b I can't suspend if usb-storage is loaded. Bisecting
> is becoming troublesome as different sets have slightly different
> problems.
> At one point (with the GREGKH usb stuff built) I had the kernel
> reporting it cannot stop the usb-storage thread so I guess that
> something later in the series made things worse (freezable workqueues?).
> 
> Clues?

Can you please try 2.6.22-rc5 with the patches from

http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc5/patches/

applied.  That should allow us to eliminate some suspects. ;-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
