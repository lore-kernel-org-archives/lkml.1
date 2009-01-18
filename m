Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZARX3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZARX3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 18:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZARX3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 18:29:37 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:52902
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZARX3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 18:29:37 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [uml-devel] [Patch] uml: fix a link error
Date: Sun, 18 Jan 2009 17:29:30 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, jdike@addtoit.com,
       linux-kernel@vger.kernel.org
References: <20090115194033.GA10926@hack.private> <200901170328.15178.rob@landley.net> <20090118083237.GA3292@hack.private>
In-Reply-To: <20090118083237.GA3292@hack.private>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901181729.31682.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 January 2009 02:32:37 Américo Wang wrote:
> >The result panics (twice) and exits, instead of giving me a shell prompt.
> >Built and run on stock Ubuntu 8.10.  (I posted about it on tuesday, but
> > nobody replied...)
>
> Hi, Rob.
>
> I tried what you said, it works very fine here, on my Fedora 10.
> Could you please tell us which kernel your host is using?

Ubuntu 8.10 stock kernel, calls itself "2.6.27-9-generic".

> and the guest?

Checking tuesday's bug report, it said:

> Linux version 2.6.28 (landley@driftwood) (gcc version 4.3.2 (Ubuntu 
> 4.3.2-1ubuntu11) ) #6 Tue Jan 13 01:54:34 CST 2009

It's the vanilla tarball (albeit extracted from source control according to 
the v2.6.28 tag rather than downloaded).

Possibly a gcc 4.3 issue?

Rob
