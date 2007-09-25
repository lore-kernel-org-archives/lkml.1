Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbXIYNlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbXIYNlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 09:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXIYNlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 09:41:00 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2918 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbXIYNk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 09:40:59 -0400
Date: Tue, 25 Sep 2007 14:40:50 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.23-rc6-mm1 -- powerpc link failure
Message-ID: <20070925134050.GA8447@shadowen.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070919092848.GG973@shadowen.org> <20070919174403.GC3115@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919174403.GC3115@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 07:44:03PM +0200, Sam Ravnborg wrote:
> On Wed, Sep 19, 2007 at 10:28:48AM +0100, Andy Whitcroft wrote:
> > I am seeing this strange link error from a PowerMac G5 (powerpc):
> > 
> >   [...]
> >     KSYM    .tmp_kallsyms2.S
> >     AS      .tmp_kallsyms2.o
> >     LD      vmlinux.o
> >   ld: dynreloc miscount for fs/built-in.o, section .opd
> >   ld: can not edit opd Bad value
> >   make: *** [vmlinux.o] Error 1
> 
> We have had this issue before.
> Try to see:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=045e72acf16054c4ed2760e9a8edb19a08053af1
> 
> Here it was caused by a weak declaration that was superflous.
> 
> I expect the workaround to be equally simple this time - or I hope so.

Yep, will investigate this as suggested.  As this problem seems to
persist thru 2.6.23-rc8-mm1 I will report it again there and my
findings.

-apw
