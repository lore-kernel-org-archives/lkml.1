Return-Path: <linux-kernel-owner+w=401wt.eu-S1763785AbYDNRmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763785AbYDNRmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758538AbYDNRmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:42:08 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:45937 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700AbYDNRmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:42:06 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 14 Apr 2008 10:42:04 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@gmail.com>
cc: Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] F_GETPATH for linux
In-Reply-To: <517f3f820804132234l48f759ddn18447531e5361754@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804141034220.20665@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0804131455030.12741@alien.or.mcafeemobile.com> 
 <200804140300.05719.arnd@arndb.de>  <Pine.LNX.4.64.0804131839010.12741@alien.or.mcafeemobile.com>
 <517f3f820804132234l48f759ddn18447531e5361754@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Michael Kerrisk wrote:

> On 4/14/08, Davide Libenzi <davidel@xmailserver.org> wrote:
> > On Mon, 14 Apr 2008, Arnd Bergmann wrote:
> >
> >  > On Monday 14 April 2008, Davide Libenzi wrote:
> >  > > I was working on some bsd/linux compatibility code, and I noticed that we
> >  > > do not have F_GETPATH. I know we can readlink /proc/PID/fd/FD (that is
> >  > > what I'm doing now, under #ifdef), but I gave a patch a shot anyway.
> >  > > Here it is, building but untested ...
> >  >
> >  > I reviewed the code path for compat_sys_fcntl{,64} for this patch, looks
> >  > good in that respect.
> >  >
> >  > > +error:
> >  > > +   free_page((unsigned long) buf);
> >  > > +   return size;
> >  > > +}
> >  > > +EXPORT_SYMBOL(fcntl_getpath);
> >  > > +
> >  >
> >  > Procfs cannot be a module, and there are no other users of this function,
> >  > so why do you export it?
> >
> >
> > Springtime export fever? :)
> >  I dropped the export. I'll repost as soon as I've five minutes to reboot
> >  my box (to test the thing a little).
> 
> Davide,
> 
> Please CC me on all kernel-userland API changes, so that I can watch
> for changes that may be needed for man-pages.

Michael, I will.



- Davide


