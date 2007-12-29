Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbXL2SUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbXL2SUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 13:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbXL2SUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 13:20:11 -0500
Received: from mx1.riseup.net ([204.13.164.18]:36075 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbXL2SUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 13:20:09 -0500
Date: Sat, 29 Dec 2007 19:20:05 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Christoph Hellwig <hch@lst.de>
Cc: Arnd Bergmann <ARNDB@de.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/8] debugfs: allow access to signed values
Message-ID: <20071229192005.10518d4c@morte>
In-Reply-To: <20071228185832.GA4462@lst.de>
References: <20071219001955.055692620@polimi.it>
	<1198080034.4747.15.camel@johannes.berg>
	<20071220131548.1d09cd62@morte>
	<200712201347.15022.ARNDB@de.ibm.com>
	<20071228185832.GA4462@lst.de>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2007 19:58:32 +0100
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Dec 20, 2007 at 01:47:13PM +0100, Arnd Bergmann wrote:
> > Also, Christoph has recently posted a suggestion for how to improve
> > the interface to allow the 'get' operation to return an error:
> > http://patchwork.ozlabs.org/cbe-oss-dev/patch?id=14962
> > 
> > I'd suggest consolidating the two changes in order to avoid merge
> > conflicts.
> 
> Stefano, I couldn't find your complete patch series.  Where are the
> other 7 patches for that series?   Anyway, I'll post my series with
> the simple attribute chanegs ASAP and I'll Cc you.  If you send me the
> latest version of your patches I'll port it ontop of my patches.

Sorry for the late reply. As Johannes said, the other patches have nothing
to do with this anyway. I had to put this patch within my patchset because I
originally wanted to send a patch which would export signed values to
debugfs, but then I solved the issue in a different fashion, and I'm not
that interested in it at the moment.

BTW, the patch I sent was just meant to allow exporting signed values
through debugfs, but in order to do that I had to change some users as well.
And being spufs an user, I don't feel that much like sending a patch
without testing on ppc64 in advance.


-- 
Ciao
Stefano
