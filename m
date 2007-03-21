Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbXCULJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbXCULJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbXCULJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:09:50 -0400
Received: from lazybastard.de ([212.112.238.170]:41475 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbXCULJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:09:49 -0400
Date: Wed, 21 Mar 2007 12:05:29 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matt Mackall <mpm@selenic.com>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070321110528.GC3785@lazybastard.org>
References: <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron> <20070318191812.GM4892@waste.org> <20070318203149.GC29295@crusty.rchland.ibm.com> <20070319170838.GP4892@waste.org> <1174328188.30079.46.camel@zod.rchland.ibm.com> <20070319195442.GT4892@waste.org> <1174338329.13341.633.camel@localhost.localdomain> <20070319223205.GZ4892@waste.org> <1174351366.13341.739.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1174351366.13341.739.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 March 2007 01:42:46 +0100, Thomas Gleixner wrote:
> On Mon, 2007-03-19 at 17:32 -0500, Matt Mackall wrote:
> 
> > > > 4. JFFS2 has its own wear-leving scheme, as do several other
> > > >    filesystems, so they probably want to bypass this piece of the stack.
> > > 
> > > JFFS2 on top of UBI delegates the wear levelling to UBI, as JFFS2s own
> > > wear levelling sucks. 
> > 
> > Ok, fine. How about LogFS, then?
> 
> LogFS can easily leverage UBI's wear algorithm.

Ok, now we have reached the absurd.  UBI quite fundamentally cannot do
wear leveling as good as LogFS can.  Simply because UBI has zero
knowledge of the _contents_ of its blocks.  Knowing whether a block is
90% garbage or not makes a great difference.

Also LogFS currently requires erasesizes of 2^n.

Thomas, I can give you my opinion on this flamewar in private - after
you have cooled off.

Jörn

-- 
When I am working on a problem I never think about beauty.  I think
only how to solve the problem.  But when I have finished, if the
solution is not beautiful, I know it is wrong.
-- R. Buckminster Fuller
