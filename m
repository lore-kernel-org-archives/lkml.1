Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbZFKQwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbZFKQwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbZFKQwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:52:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33174 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZFKQwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:52:34 -0400
Date: Thu, 11 Jun 2009 17:52:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090611165226.GV8633@ZenIV.linux.org.uk>
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org> <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 09:26:55AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 11 Jun 2009, Christoph Hellwig wrote:
> >
> > Err, no.   This adds tons of userspace code into tools/ which
> > should not be in the kernel tree but a proper package.
> 
> I disagree.
> 
> We've had tons of cases where we tried to "separate" the user-land code 
> and the kernel code, in the name of "beauty" of whatever.
> 
> It's almost invariably a disaster.
> 
> Look at oprofile. F*ck me, what a horrid piece of crap.

Yes.  So's sysfs, so's udev, so's hal, so's any number of revolting
strings of intertwined copulating tapeworms hanging off the kernel's arse.

Do you consider "put into tools/" as permission to change interface at will?
More to the point, do the authors of that stuff consider it as such?


