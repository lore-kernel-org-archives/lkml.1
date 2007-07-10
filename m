Return-Path: <linux-kernel-owner+w=401wt.eu-S1763628AbXGJVIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763628AbXGJVIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 17:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760020AbXGJVIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 17:08:06 -0400
Received: from [212.12.190.151] ([212.12.190.151]:34482 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759791AbXGJVIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 17:08:05 -0400
From: Al Boldi <a1426z@gawab.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86 setup code rewrite in C
Date: Wed, 11 Jul 2007 00:07:09 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200707102032.29124.a1426z@gawab.com> <4693F08B.5060904@zytor.com>
In-Reply-To: <4693F08B.5060904@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707110007.09728.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Al Boldi wrote:
> > H. Peter Anvin wrote:
> >> This patch set replaces the x86 setup code, which is currently all in
> >> assembly, with a version written in C, using the ".code16gcc" feature
> >> of binutils (which has been present since at least 2001.)
> >>
> >> The new code is vastly easier to read, and, I hope, debug.  It should
> >> be noted that I found a fair number of minor bugs while going through
> >> this code, and have attempted to correct them.
> >
> > I have an i810 which supends-to-ram just fine, but when booted over pxe
> > it just hangs.  Will these patches fix this, and if so, is there an easy
> > tar-ball against 2.6.22?
>
> There is absolutely no way to know, other than testing it.  There isn't
> any real reason to suspect the setup code in your case, but it's worth a
> shot, I guess.

Well it's a bit far fetched to suspect the setup code, but I have another 
i440 that suspends-to-ram when booted over pxe without any problems.  And, 
booting the i810 through dos-lilo also hangs STR, so that's why assumed it 
may be a setup code thing.

> There is a git tree on git.kernel.org you can pull, which is current
> against 2.6.22.

How can I pull a tar-ball from that without using a git client?


Thanks!

--
Al

