Return-Path: <linux-kernel-owner+w=401wt.eu-S1763997AbXISRmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763997AbXISRmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760159AbXISRmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:42:40 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36249 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbXISRmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:42:39 -0400
Date: Wed, 19 Sep 2007 19:44:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.23-rc6-mm1 -- powerpc link failure
Message-ID: <20070919174403.GC3115@uranus.ravnborg.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070919092848.GG973@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919092848.GG973@shadowen.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 10:28:48AM +0100, Andy Whitcroft wrote:
> I am seeing this strange link error from a PowerMac G5 (powerpc):
> 
>   [...]
>     KSYM    .tmp_kallsyms2.S
>     AS      .tmp_kallsyms2.o
>     LD      vmlinux.o
>   ld: dynreloc miscount for fs/built-in.o, section .opd
>   ld: can not edit opd Bad value
>   make: *** [vmlinux.o] Error 1

We have had this issue before.
Try to see:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=045e72acf16054c4ed2760e9a8edb19a08053af1

Here it was caused by a weak declaration that was superflous.

I expect the workaround to be equally simple this time - or I hope so.

	Sam
