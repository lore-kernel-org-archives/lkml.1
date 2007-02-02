Return-Path: <linux-kernel-owner+w=401wt.eu-S1751759AbXBBL2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbXBBL2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 06:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbXBBL2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 06:28:32 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:35282 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbXBBL2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 06:28:31 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 2 Feb 2007 06:27:24 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       reiserfs-dev@namesys.com
Subject: Re: [PATCH] REISERFS: Rename incorrect macro name "REISERFS_PROC_INFO".
In-Reply-To: <b6fcc0a0702020317j5776bc3ar5b1db481501c81c0@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702020626420.17280@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0702020447001.12400@CPE00045a9c397f-CM001225dbafb6>
 <b6fcc0a0702020317j5776bc3ar5b1db481501c81c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007, Alexey Dobriyan wrote:

> On 2/2/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> >   Rename the incorrect macro name "REISERFS_PROC_INFO" to
> > "CONFIG_REISERFS_PROC_INFO".
>
> It isn't incorrect. It's setup in reiserfs header files.
> You reminded me to dig out "reiserfs without proc files" cleanup which
> will get rid of REISERFS_PROC_INFO completely.
>
> > --- a/fs/reiserfs/procfs.c
> > +++ b/fs/reiserfs/procfs.c
> > @@ -20,7 +20,7 @@
> >  #include <linux/init.h>
> >  #include <linux/proc_fs.h>
> >
> > -#if defined( REISERFS_PROC_INFO )
> > +#if defined( CONFIG_REISERFS_PROC_INFO )

maybe i should just give up while i'm behind ...

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
