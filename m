Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbXEaNc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbXEaNc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 09:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXEaNcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 09:32:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbXEaNct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 09:32:49 -0400
Date: Thu, 31 May 2007 09:31:06 -0400
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Christian Volkmann <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org,
       ak@suse.de, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC: 2.6 patch] i386: remove support for the Rise CPU
Message-ID: <20070531133106.GA26030@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@stusta.de>,
	Christian Volkmann <haveaniceday@cv-sv.de>,
	linux-kernel@vger.kernel.org, ak@suse.de,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <464BB252.8010008@cv-sv.de> <464CC8E1.5010407@cv-sv.de> <20070517214754.GC398@redhat.com> <20070531052238.GX3899@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531052238.GX3899@stusta.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 07:22:38AM +0200, Adrian Bunk wrote:
 > On Thu, May 17, 2007 at 05:47:54PM -0400, Dave Jones wrote:
 > > On Thu, May 17, 2007 at 11:28:01PM +0200, Christian Volkmann wrote:
 > > 
 > >  > - Important: somebody to check other CPU types if the same behavior happens.
 > > 
 > > arch/i386/kernel/cpu/rise.c
 > > 
 > > Though, I've *never* seen or even heard of someone with one of those CPUs,
 > > so whether we need to care is questionable. The mp6 did actually make it
 > > to manufacture aparently, but I don't think anyone actually bought one.
 > > http://en.wikipedia.org/wiki/Rise_Technology for a pic of this mythical beast.
 > 
 > Considering that arch/i386/kernel/cpu/rise.o takes a few bytes in every 
 > i386 kernel image, what about removing it?

I'll be amazed if someone complains.
We'll still boot fine on those CPUs without that support code too,
we just won't advertise cx8 to userspace, and /proc/cpuinfo
won't prettyprint the name. whoopdy-do.

Should we actually find someone who a) has one and b) is crazy enough
to still run it today, we could always add this stuff back.

Signed-off-by: Dave Jones <davej@redhat.com>

	Dave

-- 
http://www.codemonkey.org.uk
