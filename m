Return-Path: <linux-kernel-owner+w=401wt.eu-S1760380AbXENUPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760380AbXENUPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759345AbXENUPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:15:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58210 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758583AbXENUPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:15:24 -0400
Date: Mon, 14 May 2007 21:15:16 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>,
       Antonino Ingargiola <tritemio@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
Message-ID: <20070514201516.GA20783@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jean Delvare <khali@linux-fr.org>,
	Antonino Ingargiola <tritemio@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org> <5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com> <20070514081022.7fcee97f@hyperion.delvare> <5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com> <20070514141437.631fcfd1@hyperion.delvare> <5486cca80705140628w5ff43ebdqf6a5413203226d5@mail.gmail.com> <20070514172138.1c870793@hyperion.delvare> <alpine.LFD.0.98.0705140914410.6739@woody.linux-foundation.org> <20070514202419.33a90f57@hyperion.delvare> <alpine.LFD.0.98.0705141139560.6739@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705141139560.6739@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 11:43:45AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 14 May 2007, Jean Delvare wrote:
> > 
> > Sure, we don't allow that. Except for xfsprogs in 2.6.1, procps in
> > 2.6.4, oprofile in 2.6.13 and udev in 2.6.19, of course.
> 
> And we really complained about it! The oprofile thing should be fixed, 
> btw, and yeah,if udev breaks any more, I'll have to stop taking patches 
> from Greg. That thing has been a disaster, and everybody involved should 
> be ashamed and now hopefully *very* aware of the fact that we don't break 
> user-level interfaces.

sysfs is an even bigger desaster.  Even if people know they can't break
userspace apis sysfs can force it on them.  As long as we tightly couple
kernel data structures and a userspace ABI that's unavoidable.  Unfortunately
sorting that mess out properly would be such a massive amount of work
that it'd alsmost require a 2.7 series.

