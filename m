Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbXIFNj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbXIFNj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 09:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbXIFNjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 09:39:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:53364 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756216AbXIFNjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 09:39:00 -0400
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 06 Sep 2007 15:38:58 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <a36005b50709060434u35d8db01n7cc448e98fdbdd37@mail.gmail.com>
Message-ID: <20070906133858.19080@gmx.net>
MIME-Version: 1.0
References: <200705312320.l4VNKS44030545@shell0.pdx.osdl.net>	
 <46DEFD3F.8020502@gmx.net>
 <a36005b50709060434u35d8db01n7cc448e98fdbdd37@mail.gmail.com>
Subject: Re: O_CLOEXEC / MSG_CMSG_CLOEXEC documentation
To: "Ulrich Drepper" <drepper@gmail.com>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+5mTJ3+fS5tcUR03H2kKZhsCle4Q0TxNXitGTfvr
 2coTUnz17zSflpRgEVJ//15IZRkI0yMZBEaw== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: yjXTcjZ1f2IsOfH2F21oqXZ4dWxlc1Zm
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich,

> On 9/5/07, Michael Kerrisk <mtk-manpages@gmx.net> wrote:
> >     O_CLOEXEC (Since Linux 2.6.23)
> >           Enable   the  close-on-exec  flag  for  the  new  file
> >           descriptor.  This is useful in multithreaded  programs
> >           since  using  a separate fcntl(2) F_SETFD operation to
> >           set the FD_CLOEXEC flag does not suffice to avoid race
> >           conditions  in multithreaded programs where one thread
> >           opens a file descriptor at the same  time  as  another
> >           thread does a fork(2) plus execve(2).
> 
> Correct,

Good.  Thanks.

> although you might want to reconsider the repetition of "in
> multithreaded programs".

Yes.

> Plus, it's also useful in other programs since it avoids the
> additional system call to fcntl.

Okay, I may add some words about this.

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

