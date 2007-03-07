Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbXCGICf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbXCGICf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 03:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXCGICf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 03:02:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbXCGICe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 03:02:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeff Dike <jdike@addtoit.com>
X-Fcc: ~/Mail/utrace
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] UML utrace support, step 1
In-Reply-To: Jeff Dike's message of  Monday, 5 March 2007 14:21:20 -0500 <20070305192120.GA7320@ccure.user-mode-linux.org>
X-Windows: let it get in *your* way.
Message-Id: <20070307080159.F27C41801C4@magilla.sf.frob.com>
Date: Wed,  7 Mar 2007 00:01:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Feb 22, 2007 at 07:19:03PM -0800, Roland McGrath wrote:
> > Your replacement patch still has utrace_regset stuff in it, so it doesn't
> > compile without the later patches in the series.  Try applying only
> > utrace-tracehook.patch from the series, then get it to build and make your
> > utrace-tracehook-um.patch.
> 
> Below is a tracehook patch for UML which goes right after
> utrace-utrace-tracehook.patch.

It does not.  That patch has regset and ptrace stuff in it.  It indeed
applies fine before or after utrace patches.  But it doesn't close to
compile without utrace-regset.patch and utrace-core.patch applied,
and even with utrace-ptrace-compat.patch it still doesn't compile for me
with a lot of complaints about TIF_SINGLESTEP not being defined where
it's used in asm/tracehook.h.


Thanks,
Roland
