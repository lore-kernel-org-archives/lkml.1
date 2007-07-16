Return-Path: <linux-kernel-owner+w=401wt.eu-S1763587AbXGPUto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763587AbXGPUto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbXGPUtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:49:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41172 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118AbXGPUtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:49:32 -0400
Date: Mon, 16 Jul 2007 21:49:30 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Harkes <jaharkes@cs.cmu.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: wrong order of arguments of ->readdir()
Message-ID: <20070716204930.GK21668@ftp.linux.org.uk>
References: <200707152359.l6FNx3oN023117@hera.kernel.org> <20070716134424.0cd870b4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716134424.0cd870b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 01:44:24PM -0700, Andrew Morton wrote:
> Today is not being a good day.
> 
> This bug was already fixed.   The following mistakes were made:
> 
> a) Jan's patch was misleadingly titled "coda: avoid lockdep warning in
>    coda_readdir"
> 
> b) Jan's patch had no changelog
> 
> c) Jen's patch was not cc'ed to any mailing list
 
... said patch (presumably being an obvious fix of obvious roothole)
had not been sent to mainline immediately.

> d) Al's patch was not sent to the maintainer.  Nor to me.  Nor was it
>    staged in any tree which I can get at so that I could inform people of
>    the upcoming conflict/duplication/etc.
 
Coda is still maintained?  That's certainly news to me - I'm not being
sarcastic, but my impression had been that coda got abandoned several
years ago.
