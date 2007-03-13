Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbXCMPNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbXCMPNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbXCMPNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:13:45 -0400
Received: from colin.muc.de ([193.149.48.1]:4265 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbXCMPNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:13:45 -0400
Date: 13 Mar 2007 16:13:43 +0100
Date: Tue, 13 Mar 2007 16:13:43 +0100
From: Andi Kleen <ak@muc.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vladimir Brik <no.hope@gmail.com>
Subject: Re: [3/6] 2.6.21-rc3: known regressions
Message-ID: <20070313151343.GA3947@muc.de>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <20070313125006.GT18731@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313125006.GT18731@stusta.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject    : AMD Elan: Crash after "Allocating PCI resources"
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8161
> Submitter  : Vladimir Brik <no.hope@gmail.com>
> Handled-By : Andi Kleen <ak@muc.de>
> Status     : problem is being debugged

It uses RDTSC when it shouldn't. Already got a fix for that.

-Andi
