Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbXKISqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbXKISqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 13:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbXKISqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 13:46:39 -0500
Received: from xenotime.net ([66.160.160.81]:47934 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754742AbXKISqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 13:46:38 -0500
Date: Fri, 9 Nov 2007 10:46:35 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23: GRUB reports "Setup signature not found"
Message-Id: <20071109104635.11e504d2.rdunlap@xenotime.net>
In-Reply-To: <4734A9B6.1080404@zytor.com>
References: <47348F54.2080507@redhat.com>
	<20071109085905.3c2a78cd.rdunlap@xenotime.net>
	<4734A9B6.1080404@zytor.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Nov 2007 10:40:54 -0800 H. Peter Anvin wrote:

> Randy Dunlap wrote:
> > On Fri, 09 Nov 2007 11:48:20 -0500 Chuck Ebbert wrote:
> > 
> >> Multiple people have now reported this error message with 2.6.23.
> >> Updating GRUB fixes it:
> >>
> >> https://bugzilla.redhat.com/show_bug.cgi?id=370391
> >> https://bugzilla.redhat.com/show_bug.cgi?id=371321
> > 
> > Thanks for the info.
> > A better fix IMHO would be if one could get lilo to work.  :)
> > 
> > ---
> > ~Randy [who is fed up with grub]
> 
> BTW, I definitely can agree with your feeling about grub (which is part 
> of why I maintain a different boot loader suite.)  However, if you know 
> of any LILO problems, please speak up.

I don't know of any lilo-specific problems and didn't mean to imply
that LILO is at fault.

The problems that I have seen when I have tried to switch from
grub to LILO are more like config issues:
either "can't find root device" or
"cannot open /dev/console" or other initrd/initramfs issues.

Thanks,
---
~Randy
