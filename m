Return-Path: <linux-kernel-owner+w=401wt.eu-S1752166AbZIUK4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbZIUK4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 06:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZIUK4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 06:56:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46288 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZIUK4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 06:56:46 -0400
Subject: Re: ipw2200: firmware DMA loading rework
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Tso Ted <tytso@mit.edu>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Zhu Yi <yi.zhu@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mel Gorman <mel@skynet.ie>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       James Ketrenos <jketreno@linux.intel.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw2100-devel@lists.sourceforge.net" 
	<ipw2100-devel@lists.sourceforge.net>
In-Reply-To: <200909211246.34774.bzolnier@gmail.com>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	 <200909211159.27344.bzolnier@gmail.com> <20090921100813.GL12726@csn.ul.ie>
	 <200909211246.34774.bzolnier@gmail.com>
Date: Mon, 21 Sep 2009 13:56:48 +0300
Message-Id: <1253530608.5216.17.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 12:46 +0200, Bartlomiej Zolnierkiewicz wrote:
> > > I don't know why people don't see it but for me it has a memory management
> > > regression and reliability issue written all over it.
> > 
> > Possibly but drivers that reload their firmware as a response to an
> > error condition is relatively new and loading network drivers while the
> > system is already up and running a long time does not strike me as
> > typical system behaviour.
> 
> Loading drivers after boot is a typical desktop/laptop behavior, please
> think about hotplug (the hardware in question is an USB dongle).

Yeah, I wonder what broke things. Did the wireless stack change in
2.6.31-rc1 too? IIRC Mel ruled out page allocator changes as a suspect.

			Pekka

