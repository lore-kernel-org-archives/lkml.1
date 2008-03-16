Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYCPXeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYCPXeq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYCPXeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:34:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbYCPXeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:34:37 -0400
Date: Sun, 16 Mar 2008 16:33:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       =?ISO-8859-15?Q?Linas_=B4virblis?= <0x0007@gmail.com>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
In-Reply-To: <200803170018.52663.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0803161628410.3020@woody.linux-foundation.org>
References: <200803170018.52663.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Mar 2008, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9983
> Subject		: PROBLEM: 2.6.25-rc1-git2 freezes when accessing external USB hard disk (ehci-hcd)
> Submitter	: Linas ®virblis <0x0007@gmail.com>
> Date		: 2008-02-13 22:38 (33 days old)
> References	: http://lkml.org/lkml/2008/2/13/566

This is most likely already fixed by commit
e82cc1288fa57857c6af8c57f3d07096d4bcd9d9.

Unless Linas can reproduce it with a newer kernel (I'm cutting an -rc6 
right now, but any -git snapshot in the last few days should work) this 
one should be closed.  We can't keep things open just because the tester 
hasn't tested.

		Linus
