Return-Path: <linux-kernel-owner+w=401wt.eu-S1763298AbXHNXZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763298AbXHNXZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 19:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbXHNXZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 19:25:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbXHNXZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 19:25:07 -0400
Date: Tue, 14 Aug 2007 19:24:30 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Joe Perches <joe@perches.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software
	Suspend, aka swsusp):
Message-ID: <20070814232430.GA9325@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Joe Perches <joe@perches.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com> <200708132338.25925.rjw@sisk.pl> <20070814070528.GA2903@elf.ucw.cz> <200708141937.06676.rjw@sisk.pl> <1187114231.32555.105.camel@localhost> <alpine.LFD.0.999.0708141112110.30176@woody.linux-foundation.org> <20070814112237.a5f1e1a4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814112237.a5f1e1a4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 11:22:37AM -0700, Andrew Morton wrote:
 > On Tue, 14 Aug 2007 11:15:41 -0700 (PDT)
 > Linus Torvalds <torvalds@linux-foundation.org> wrote:
 > 
 > > In other words, it would be much better to just have per-file markers, 
 > > along with some per-subdirectory stuff or similar.
 > 
 > And a `make maintainers' target to pull it all together..
 > 
 > (perhaps we could add a
 > 
 > 	maintainer <keyword>
 > 
 > record to Kconfig, then `make maintainers' goes and looks up <keyword>
 > somewhere and does something with it)

Not everything that's in MAINTAINERS has a Kconfig entry though,
so it really needs to live in the .c/.h files.

	Dave


-- 
http://www.codemonkey.org.uk
