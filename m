Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbYKDU3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbYKDU3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYKDU3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:29:35 -0500
Received: from lazybastard.de ([212.112.238.170]:46332 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbYKDU3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:29:34 -0500
Date: Tue, 4 Nov 2008 21:29:09 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James.Bottomley@HansenPartnership.com,
       michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org,
       osd-dev@open-osd.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Sami.Iren@seagate.com, pw@padd.com
Subject: Re: [PATCH 03/18] libosd: OSDv1 Headers
Message-ID: <20081104202909.GE16036@logfs.org>
References: <491073BB.4000900@panasas.com> <1225817046-5946-1-git-send-email-bharrosh@panasas.com> <20081104111037.bcae04e5.akpm@linux-foundation.org> <20081104194240.GC16036@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081104194240.GC16036@logfs.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 November 2008 20:42:40 +0100, Jörn Engel wrote:
> On Tue, 4 November 2008 11:10:37 -0800, Andrew Morton wrote:
> > 
> > etc, etc, etc.   Please review all that.
> 
> One easy way to review 98% is to include the header in an otherwise
> empty foo.c and compile that.  The remaining 2% are hidden behind
> different config options and architectures.  Although your header may be
> fine on that front.

Btw, running such a script on include/linux detects a lot of trouble
even with i386 allnoconfig.  Most of which looks it could be 'fixed' by
a drunken monkey inserting #includes.  But some of those #includes may
be fs.h and pull the kitchensink, adding tons of dependencies and some
compile time.

Unsure.

Jörn

-- 
Rules of Optimization:
Rule 1: Don't do it.
Rule 2 (for experts only): Don't do it yet.
-- M.A. Jackson
