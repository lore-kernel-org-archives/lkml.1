Return-Path: <linux-kernel-owner+w=401wt.eu-S1751897AbXEXPId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbXEXPId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 11:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXEXPIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 11:08:22 -0400
Received: from [81.2.110.250] ([81.2.110.250]:59077 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751782AbXEXPIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 11:08:20 -0400
Date: Thu, 24 May 2007 16:11:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Uwe Bugla <uwe.bugla@gmx.de>, Ken Chen <kenchen@google.com>,
       xfs-masters@oss.sgi.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Chinner <dgc@sgi.com>,
       Andrea Righi <righiandr@users.sourceforge.net>,
       Christoph Lameter <clameter@sgi.com>, linux-ide@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Francis Russell <francisrussell@btopenworld.com>,
       Alan Cox <alan@redhat.com>, Andi Kleen <ak@suse.de>, discuss@x86-64.org,
       Ben Collins <ben.collins@ubuntu.com>
Subject: Re: 2.6.22-rc2: known regressions with patches
Message-ID: <20070524161116.047c55e9@the-village.bc.nu>
In-Reply-To: <46559B62.5040903@googlemail.com>
References: <46559B62.5040903@googlemail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject    : pata_via appears to incorrectly detects 40-pin cable
> References : http://lkml.org/lkml/2007/5/17/273
>              http://bugzilla.kernel.org/show_bug.cgi?id=8142
> Submitter  : Francis Russell <francisrussell@btopenworld.com>
> Status     : Not really a regression. Alan seems to have a general fix.
>              (Tejun Heo)

The laptop one has been resolved, tested and fired at Andrew.

Note btw that the bugzilla and email refer to two differing bugs. The
SATA one (bugzilla ref) has gone to Jeff and is a different fix.

Alan
