Return-Path: <linux-kernel-owner+w=401wt.eu-S932194AbXCNPev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbXCNPev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932134AbXCNPev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:34:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:41407 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbXCNPeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:34:50 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 14 Mar 2007 08:29:32 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Frank Seidel <frank@kernalert.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 5/9] signalfd/timerfd v3 - signalfd compat code ...
In-Reply-To: <200703141619.28505.frank@kernalert.de>
Message-ID: <Pine.LNX.4.64.0703140827270.1021@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5031.1173654242.5>
 <200703141619.28505.frank@kernalert.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-231663576-1173886172=:1021"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-231663576-1173886172=:1021
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 14 Mar 2007, Frank Seidel wrote:

> On Monday 12 March 2007 20:19:27 Davide Libenzi wrote:
> Hi,
> i'm not (at least until yet) really that familiar with the kernel, but=20
> currently trying to get into it also via reading of code and patches=20
> here. So please don't take my comments in this (and posibly following)
> mails to serious. ;-)
>=20
> > +asmlinkage long compat_sys_signalfd(int ufd,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 =A0 =A0const compat_sigset_t __user=20
> *sigmask,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 =A0 =A0compat_size_t sigsetsize)
> > +{
> > +=A0=A0=A0=A0=A0compat_sigset_t ss32;
> > +=A0=A0=A0=A0=A0sigset_t tmp;
> > +=A0=A0=A0=A0=A0sigset_t __user *ksigmask;
> > +
> Would it be good to put this in a
>=20
> if (sigmask) {
>=20
> like its e.g. done in compat_sys_epoll_pwait or would this be
> totally useless here?

On the contrary or epoll_pwait (same family of ppoll/pselect), the sigmask=
=20
is needed here, by the API definition.



- Davide


--1795850513-231663576-1173886172=:1021--
