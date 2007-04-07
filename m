Return-Path: <linux-kernel-owner+w=401wt.eu-S965698AbXDGJuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965698AbXDGJuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 05:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965650AbXDGJuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 05:50:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47749 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965711AbXDGJuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 05:50:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] high-res timers: UP resume fix
Date: Sat, 7 Apr 2007 11:53:44 +0200
User-Agent: KMail/1.9.5
Cc: tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704071148.43136.rjw@sisk.pl> <20070407094705.GA20998@elte.hu>
In-Reply-To: <20070407094705.GA20998@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704071153.45260.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 7 April 2007 11:47, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > We do in on_each_cpu() unconditionally. I missed that.
> > 
> > BTW, the on_each_cpu() in clock_was_set() is unnecessary, because 
> > timekeeping_resume() is always run on one CPU.
> 
> yes - but that's not the only place where we do clock_was_set(), and the 
> on_each_cpu() is necessary in every other case. So i think the right 
> solution was the patch i did: to split the resume functionality from the 
> clock_was_set() functionality.

Agreed.

Rafael
