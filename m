Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbXKICLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbXKICLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 21:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbXKICL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 21:11:28 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53744 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbXKICL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 21:11:28 -0500
Date: Thu, 8 Nov 2007 21:11:25 -0500
Message-Id: <200711090211.lA92BPB5022618@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Paul Albrecht <albrecht@rdi1.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: unionfs and sys_readahead 
In-reply-to: Your message of "Wed, 07 Nov 2007 14:43:39 CST."
             <1194468220.5538.10.camel@albrecht.rdi1.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1194468220.5538.10.camel@albrecht.rdi1.com>, Paul Albrecht writes:
> On Wed, 2007-11-07 at 19:53 +0000, Denys Vlasenko wrote:
> > On Tuesday 06 November 2007 22:01, Paul Albrecht wrote:
> > > Hi,
> > > 
> > > Whenever I use readahead-list on a union mounted file system I get a
> > > segfault and kernel oops so I'm wondering whether or not the linux
> > > unionfs supports sys_readahead.
> > > 
> > > Anyone know? I'm not usually subscribed to the lkml so please cc me in
> > > your response. Thanks.
> > 
> > Please show actual oops output.
> > 
> > Also: what kernel version do you use? any extra patch(es) applied? .config?
> 
> I'm using a stock generic kernel that's shipped with ubuntu. Here's my
> dmesg output containing two oops. The first occurs during boot and the
> second happens whenever I run readahead-list from the command line
> against a file list containing an entry in a union mounted filesystem:
[...]

> [   25.551441] Registering unionfs 1.4

The problem appears most likely because this version of Ubuntu is still
using the very old Unionfs 1.x.  I wasn't able to reproduce the bug with the
latest Unionfs 2.x.  I'm in touch with the Ubuntu guys to try and help them
move to 2.x.

Cheers,
Erez.
