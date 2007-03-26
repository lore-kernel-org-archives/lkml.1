Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbXCZLfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbXCZLfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbXCZLfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:35:09 -0400
Received: from lazybastard.de ([212.112.238.170]:60615 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbXCZLfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:35:07 -0400
Date: Mon, 26 Mar 2007 13:30:30 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Matt Mackall <mpm@selenic.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070326113030.GA22501@lazybastard.org>
References: <20070319170838.GP4892@waste.org> <1174328188.30079.46.camel@zod.rchland.ibm.com> <20070319195442.GT4892@waste.org> <1174338329.13341.633.camel@localhost.localdomain> <20070319223205.GZ4892@waste.org> <1174351366.13341.739.camel@localhost.localdomain> <20070321110528.GC3785@lazybastard.org> <1174476334.10840.49.camel@localhost.localdomain> <20070325200826.GA19691@lazybastard.org> <1174906146.1542.18.camel@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1174906146.1542.18.camel@sauron>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 March 2007 13:49:06 +0300, Artem Bityutskiy wrote:
> On Sun, 2007-03-25 at 22:08 +0200, Jörn Engel wrote:
> > 
> > Logical volume management can just as easily move its management
> > information into a table, instead of having it spread across all blocks.
> > Blocks can keep their original size.  Since you have to scan flash
> > anyway, you can also scan for a table, compare a magical number and do
> > some extra check to protect yourself against a UBI image inside some
> > logical volume.  No big deal.
> 
> First off, I see these no big deal statements for years already, and no
> decent implementation proved by usage in real world. Could we please,
> move these academic discussions to another thread?

You could wait a day, then reread what I wrote.  Maybe you will notice
that what I wrote is not identical to what we have discussed about a
year ago and you seem to have read.

You may also want to reread this:
||[ This was not a request for UBI to be changed.  The only purpose was to
||illustrate that LogFS is not broken.  The previous thread suggested
||otherwise and I just couldn't leave it at that. ]

Jörn

-- 
tglx1 thinks that joern should get a (TM) for "Thinking Is Hard"
-- Thomas Gleixner
