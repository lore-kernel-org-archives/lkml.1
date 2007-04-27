Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbXD0TBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbXD0TBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757104AbXD0TBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:01:37 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:38235 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757087AbXD0TB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 15:01:28 -0400
Date: Fri, 27 Apr 2007 15:01:27 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Acker <dacker@roinet.com>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Lennert Buytenhek <buytenh@wantstofly.org>,
       Jeff Garzik <jeff@garzik.org>, Netdev List <netdev@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [RFT] e100 driver on ARM
Message-ID: <20070427190127.GB5578@csclub.uwaterloo.ca>
References: <44FC0261.6010807@garzik.org> <20060904123123.GB1285@xi.wantstofly.org> <460AF480.7050609@intel.com> <460B4BF2.1070803@roinet.com> <20070329141041.GA3510@csclub.uwaterloo.ca> <46239138.4040408@roinet.com> <20070417173507.GB5575@csclub.uwaterloo.ca> <4630D116.4080202@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4630D116.4080202@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 09:19:34AM -0700, H. Peter Anvin wrote:
> Why wouldn't that be permitted?  It, in fact, happens all the time (the
> host bridge withdraws the GNT# line and raises STOP#, which does a
> Termination With Data of the bus transfer.)  This is a normal event and
> if you can't handle it you won't work with many host bridges at all.

Well there must have been something else wrong then.  Certainly I saw
data corruption on a rtl8139.  No problems with the same hardware using
a geode SC1200, so I have no idea.  I liked the speed of the PXA255 a
lot better than the slow poke SC1200.

--
Len Sorensen
