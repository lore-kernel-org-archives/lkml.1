Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbZDIAmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbZDIAmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 20:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071AbZDIAmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 20:42:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:37596 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494AbZDIAmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 20:42:45 -0400
Subject: Re: intel-iommu: Add for_each_iommu() and for_each_active_iommu()
 macros
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20090408110037.GD17321@elte.hu>
References: <200904062159.n36Lx1OJ001967@hera.kernel.org>
	 <20090406175918.c38654b2.akpm@linux-foundation.org>
	 <1239066583.22733.258.camel@macbook.infradead.org>
	 <20090408110037.GD17321@elte.hu>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 17:42:32 -0700
Message-Id: <1239237752.3411.655.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 13:00 +0200, Ingo Molnar wrote:
> * David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Mon, 2009-04-06 at 17:59 -0700, Andrew Morton wrote:
> > > 
> > > Three days old?  Never been in linux-next afaict.
> > > 
> > > Please don't do that.

It turns out they had actually been in linux-next, just not for long.

> > Sorry about that. There was some confusion about whether it was 
> > going via Ingo's or my tree, and it ended up in neither. It 
> > depended on certain things in Ingo's tree, so I couldn't easily 
> > add it to my tree any earlier.
> 
> Well, they could have ended up in the x86 tree or in the IOMMU tree, 
> but the patches were all very late and went through various review 
> rounds with me so they had no chance to end up there in a finished 
> state before the merge window.
> 
> I didnt mind you pushing them to Linus separately and gave an 
> Acked-by for the bits and for that merge route, but all the usual 
> protocols still have to be followed if you do that: review, testing, 
> proper exposure.

To avoid extra merges, my plan was to let Linus pull the original
iommu-2.6.git tree, then fast-forward to HEAD and apply the suspend
patches which depended on your new stuff. Then leave them to soak for as
long as possible before asking Linus to pull again.

If Linus had pulled the iommu-2.6.git tree on Tuesday when I first
asked, the suspend set would have been in linux-next for longer. Perhaps
if I'd had the wit to remember to include a diffstat on Tuesday's pull
request... :)

-- 
dwmw2

