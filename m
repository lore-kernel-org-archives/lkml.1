Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbYBKPRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbYBKPRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbYBKPRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:17:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58707 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbYBKPRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:17:11 -0500
Date: Mon, 11 Feb 2008 07:16:27 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Brice Goglin <Brice.Goglin@ens-lyon.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc1
Message-ID: <20080211071627.49b781cc@laptopd505.fenrus.org>
In-Reply-To: <47AFFB9F.4030902@ens-lyon.org>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
	<47AFFB9F.4030902@ens-lyon.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 08:39:11 +0100
Brice Goglin <Brice.Goglin@ens-lyon.org> wrote:

> Linus Torvalds wrote:
> >  - Lots of cleanups from the x86 merge (making more and more use of
> > common files), but also the big page attribute stuff is in and
> > caused a fair amount of churn, and while most of the issues should
> > have been very obvious and all got fixed, this is definitely one of
> > those things that we want a lot of very wide testing of to make
> > sure nothing regressed. 
> 
> Now that __ioremap isn't available anymore, is there anything in the
> new pageattr stuff to replace a manual __ioremap with __PAGE_PCD or

if you want uncached memory, use iorenmap_uncached...

> __PAGE_PSE? or do we have to wait for 2.6.26 to bring PAT support? I

__PAGE_PSE is the large page bit... that should be managed by the core for sure.
(yes I know that the same bit may have different meanings, but it's not __PAGE_PSE then).
PAT has a bunch of complications that really need to be resolved in the core
(eg how to deal with aliases etc etc)

> don't see any new function accepting random page attributes as
> __ioremap did.

correct

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
