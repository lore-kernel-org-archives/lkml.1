Return-Path: <linux-kernel-owner+w=401wt.eu-S1762147AbXGJRcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762147AbXGJRcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762227AbXGJRcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:32:39 -0400
Received: from [212.12.190.11] ([212.12.190.11]:34420 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760165AbXGJRci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:32:38 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: x86 setup code rewrite in C
Date: Tue, 10 Jul 2007 20:32:29 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707102032.29124.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> This patch set replaces the x86 setup code, which is currently all in
> assembly, with a version written in C, using the ".code16gcc" feature
> of binutils (which has been present since at least 2001.)
>
> The new code is vastly easier to read, and, I hope, debug.  It should
> be noted that I found a fair number of minor bugs while going through
> this code, and have attempted to correct them.

I have an i810 which supends-to-ram just fine, but when booted over pxe it 
just hangs.  Will these patches fix this, and if so, is there an easy 
tar-ball against 2.6.22?


Thanks!

--
Al

