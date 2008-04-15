Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYDORoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYDORoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 13:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbYDORn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 13:43:58 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:46299 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbYDORn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 13:43:57 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 15 Apr 2008 10:43:53 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@ftp.linux.org.uk>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] F_GETPATH implementation (rev 2)
In-Reply-To: <cfd18e0f0804142334w23a0f492we6b0a47ebee055f7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804151038250.8218@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0804141700010.6238@alien.or.mcafeemobile.com> 
 <alpine.LFD.1.00.0804141931070.2879@woody.linux-foundation.org>
 <cfd18e0f0804142334w23a0f492we6b0a47ebee055f7@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008, Michael Kerrisk wrote:

> On Tue, Apr 15, 2008 at 4:41 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >
> > On Mon, 14 Apr 2008, Davide Libenzi wrote:
> > >
> > > This is a small patch to support BSD's F_GETPATH on Linux.
> > > IMO the simplicity of the patch and the portability advantages makes it
> > > worth it. I'll leave to others to further comments it.
> >
> > So, I'd like to know who (if anybody) really uses F_GETPATH.
> 
> Davide described this as "BSD's F_GETPATH".  It's worth clarifying
> that more accurately this is "MacOS's F_GETPATH".  I can't find any
> trace of F_GETPATH on Net/Open/FreeBSD, Solaris doesn't seem to have
> it either, and none of the other systems I checked has it either.

Oh, I thought it was a common BSD-isdh thing. I did find it inside some 
OSX code indeed.
Given this, and given that the interface is not that great too (buffer 
size bolt in), I think we can safely drop it.



- Davide


