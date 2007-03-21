Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbXCULSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbXCULSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbXCULSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:18:23 -0400
Received: from www.osadl.org ([213.239.205.134]:46131 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752234AbXCULSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:18:22 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Matt Mackall <mpm@selenic.com>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070321110528.GC3785@lazybastard.org>
References: <20070318162720.GI10459@waste.org>
	 <1174236579.17249.6.camel@sauron> <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org>
	 <1174338329.13341.633.camel@localhost.localdomain>
	 <20070319223205.GZ4892@waste.org>
	 <1174351366.13341.739.camel@localhost.localdomain>
	 <20070321110528.GC3785@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 21 Mar 2007 12:25:34 +0100
Message-Id: <1174476334.10840.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 12:05 +0100, Jörn Engel wrote:
> On Tue, 20 March 2007 01:42:46 +0100, Thomas Gleixner wrote:
> > On Mon, 2007-03-19 at 17:32 -0500, Matt Mackall wrote:
> > 
> > > > > 4. JFFS2 has its own wear-leving scheme, as do several other
> > > > >    filesystems, so they probably want to bypass this piece of the stack.
> > > > 
> > > > JFFS2 on top of UBI delegates the wear levelling to UBI, as JFFS2s own
> > > > wear levelling sucks. 
> > > 
> > > Ok, fine. How about LogFS, then?
> > 
> > LogFS can easily leverage UBI's wear algorithm.
> 
> Ok, now we have reached the absurd.  UBI quite fundamentally cannot do
> wear leveling as good as LogFS can.  Simply because UBI has zero
> knowledge of the _contents_ of its blocks.  Knowing whether a block is
> 90% garbage or not makes a great difference.
> 
> Also LogFS currently requires erasesizes of 2^n.

Last time I talked to you about that, you said it would be possible and
fixable. We talked about several mechanisms, which would allow a
filesystem or other users to hint such things to UBI.

Even if the LogFS wear levelling is so superior, it CAN'T do across
device wear levelling.

	tglx


