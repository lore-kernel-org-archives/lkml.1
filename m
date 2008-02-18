Return-Path: <linux-kernel-owner+w=401wt.eu-S1760076AbYBRSk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076AbYBRSk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 13:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYBRSkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 13:40:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757425AbYBRSko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 13:40:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Rob Landley <rob@landley.net>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: Compiling with 2.6.25-rc2 with binutils 2.17 fails?
In-Reply-To: Rob Landley's message of  Monday, 18 February 2008 04:39:41 -0600 <200802180439.41928.rob@landley.net>
References: <200802161727.21312.rob@landley.net>
	<20080218030910.C2CB1270195@magilla.localdomain>
	<200802180439.41928.rob@landley.net>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080218184037.AAE87270196@magilla.localdomain>
Date: Mon, 18 Feb 2008 10:40:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm poking at it.  Something in my cross compiling setup is driving this bit 
> screwy:
> 
>   i686-nm arch/x86/vdso/vdso32-sysenter.so.dbg | 

Show me the output of just this.

> sed -n -e 's/^00*/0/' -e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$/ = 
> 0x;/p' | LC_ALL=C sort > arch/x86/vdso/vdso32-sysenter-syms.lds

Also show me the vdso32-sysenter-syms.lds file.


Thanks,
Roland
