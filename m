Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbYD2W23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbYD2W23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbYD2W2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:28:20 -0400
Received: from 1wt.eu ([62.212.114.60]:3579 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbYD2W2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:28:19 -0400
Date: Wed, 30 Apr 2008 00:24:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mark Rustad <mrustad@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Timur Tabi <timur@freescale.com>,
       Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Why use /bin/sh in kernel build system?
Message-ID: <20080429222456.GM8474@1wt.eu>
References: <481529B6.6030802@freescale.com> <8FEAC32C-868F-468C-B383-8450D400691C@e18.physik.tu-muenchen.de> <48173607.6080307@freescale.com> <20080429164501.GA18018@uranus.ravnborg.org> <F963C774-E80A-48C6-AC86-681232CEE6CF@gmail.com> <20080429214107.GA22735@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429214107.GA22735@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 01:41:07AM +0400, Alexey Dobriyan wrote:
> On Tue, Apr 29, 2008 at 03:27:02PM -0500, Mark Rustad wrote:
> > On Apr 29, 2008, at 11:45 AM, Sam Ravnborg wrote:
> >
> >>> I read in the latest Linux Journal magazine that someone noticed that 
> >>> even
> >>> though the kernel scripts say #!/bin/sh, many of them are really bash 
> >>> scripts.
> >>> This person went through the effort of changing the script to be true 
> >>> 'sh'
> >>> scripts.  Has that code been merged in?
> >>
> >> I have no patches pending but I may have lost them.
> >> As I am 100% ignorant about what is bash and what is not bash specialities
> >> I will more or less be blind when I apply them so I hope they are well
> >> tested.
> >
> >
> > So why use /bin/sh ever in the kernel build system? I consciously began 
> > using /bin/bash consistently in scripts years ago because you just never 
> > know what you get when you use /bin/sh. I remember replacing /bin/sh with 
> > /bin/bash in gcc's build system to get it to work on some system at some 
> > point. Life is too short to keep having to fight silliness like this and I 
> > can't see a valid reason why a system building a Linux kernel, or for that 
> > matter gcc, should not have the bash shell installed on it.
> 
> Think harder.

Hint: not every joe user may install bash into /bin... That's why we
see some scripts begin with "/usr/bin/env bash" as there are less
systems without env in /usr/bin than systems without bash in /bin (or
at all).

Willy

