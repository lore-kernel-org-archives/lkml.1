Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbXJ0RJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbXJ0RJv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 13:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbXJ0RJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 13:09:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49029 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbXJ0RJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 13:09:43 -0400
Date: Sat, 27 Oct 2007 10:05:43 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Kosina <jikos@jikos.cz>, Gabriel C <nix.or.die@googlemail.com>,
       a.zummo@towertech.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com
Subject: Re: BUG: lock held when returning to user space
Message-ID: <20071027100543.53ea96a8@laptopd505.fenrus.org>
In-Reply-To: <1193501369.5648.78.camel@lappy>
References: <472348F6.6050100@googlemail.com>
	<Pine.LNX.4.64.0710271707140.18815@twin.jikos.cz>
	<20071027084713.72733460@laptopd505.fenrus.org>
	<1193501369.5648.78.camel@lappy>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007 18:09:29 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 
> 
> Right, the fd could be transferred using unix sockets or fork(). That
> would indeed seriously break a mutex.
>


or just multi-threaded app..
 
> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
