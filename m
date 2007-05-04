Return-Path: <linux-kernel-owner+w=401wt.eu-S1031381AbXEDQpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031381AbXEDQpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031383AbXEDQpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:45:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55891 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031381AbXEDQpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:45:51 -0400
Date: Fri, 4 May 2007 09:45:49 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: l.genoni@oltrelinux.com
cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Rajib Majumder <rajibm2005@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, l.genoni@sns.it
Subject: Re: Kernel Scalability
In-Reply-To: <Pine.LNX.4.64.0705021933320.14034@Phoenix.oltrelinux.com>
Message-ID: <Pine.LNX.4.64.0705040943540.22097@schroedinger.engr.sgi.com>
References: <6278d2220705020843l718b3272k5d6ebf8b827d0806@mail.gmail.com>
 <Pine.LNX.4.64.0705021933320.14034@Phoenix.oltrelinux.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, l.genoni@oltrelinux.com wrote:

> To stay on systems probably more familiar to the user who asked this question,
> there are also some 64 core X86_64 bot AMD and Intel out there, here the 2.6
> kernel is doing very well even on those intel CPU with shared L2 cache.
> I have some 16 and 32 core Opteron and never had scalability problems.
> You have to pay a lot of attention to your kernel configuration  (100 HZ, just
> BKL preemption), and to the filesystems you decide to use.

It becomes a hardware issue at higher cpu counts. Commodity hardware is 
not designed to handle these high processor counts thus workarounds like 
listed above become necessary. Our 512 processor systems have been running 
with 1024 HZ for a long time. Plus you really need a good filesystem 
(XFS).

