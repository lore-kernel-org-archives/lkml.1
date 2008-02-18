Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbYBRW04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbYBRW04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbYBRW0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:26:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbYBRW0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:26:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Rob Landley <rob@landley.net>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: Compiling with 2.6.25-rc2 with binutils 2.17 fails?
In-Reply-To: Rob Landley's message of  Monday, 18 February 2008 15:53:04 -0600 <200802181553.05313.rob@landley.net>
References: <200802161727.21312.rob@landley.net>
	<200802180439.41928.rob@landley.net>
	<20080218184037.AAE87270196@magilla.localdomain>
	<200802181553.05313.rob@landley.net>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080218222614.E93CC270196@magilla.localdomain>
Date: Mon, 18 Feb 2008 14:26:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > sed -n -e 's/^00*/0/' -e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$/ =
> > > 0x;/p' | LC_ALL=C sort > arch/x86/vdso/vdso32-sysenter-syms.lds
> >
> > Also show me the vdso32-sysenter-syms.lds file.
> 
> Attached.

The contents of this file are fine.  If all the vdso32-*-syms.lds files
look sane, then your problem is just with the shell commands (cmd_vdso32sym)
that compare them.


Thanks,
Roland
