Return-Path: <linux-kernel-owner+w=401wt.eu-S1760298AbXENURT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298AbXENURT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbXENURJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:17:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58226 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbXENURG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:17:06 -0400
Date: Mon, 14 May 2007 21:17:04 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Antonino Ingargiola <tritemio@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
Message-ID: <20070514201704.GB20783@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jean Delvare <khali@linux-fr.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Antonino Ingargiola <tritemio@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com> <20070514081022.7fcee97f@hyperion.delvare> <5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com> <20070514141437.631fcfd1@hyperion.delvare> <5486cca80705140628w5ff43ebdqf6a5413203226d5@mail.gmail.com> <20070514172138.1c870793@hyperion.delvare> <alpine.LFD.0.98.0705140914410.6739@woody.linux-foundation.org> <20070514202419.33a90f57@hyperion.delvare> <alpine.LFD.0.98.0705141139560.6739@woody.linux-foundation.org> <20070514212807.246c0281@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514212807.246c0281@hyperion.delvare>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 09:28:07PM +0200, Jean Delvare wrote:
> > And we really complained about it! The oprofile thing should be fixed, 
> > btw, and yeah,if udev breaks any more, I'll have to stop taking patches 
> > from Greg. That thing has been a disaster, and everybody involved should 
> > be ashamed and now hopefully *very* aware of the fact that we don't break 
> > user-level interfaces.
> > 
> > (Right now, I suspect we may have a loop setup regression. Not sure)
> 
> While I'm all for keeping things relatively stable and not asking the
> user to constantly upgrade user-space, I believe that we just can't
> promise to never break user-level interfaces while keeping the
> development pace we have right now. We can promise to grant people
> significant delay before we drop compatibility options, but "forever"
> doesn't scale.

never with a loong deprecations period.  At least for APIs that are not
private to a single obscure driver.  But this would require people actually
beeing aware of creating ABIs, and maybe someone with half a clue reviewing
them. Which of course is not the case today, thanks to ioctls, procfs, sysfs,
debugfs and co people can create userspace ABIs without a single though
easily, and they happily do it.

