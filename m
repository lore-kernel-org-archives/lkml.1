Return-Path: <linux-kernel-owner+w=401wt.eu-S933457AbXCEVoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457AbXCEVoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933647AbXCEVoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:44:14 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:37323 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457AbXCEVoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:44:13 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 Mar 2007 13:44:10 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch - v2/resend] epoll ready set loops diet ...
In-Reply-To: <45EC8DF9.6060407@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703051343000.4907@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703051308060.4907@alien.or.mcafeemobile.com>
 <45EC8DF9.6060407@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-2052709138-1173131050=:4907"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-2052709138-1173131050=:4907
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 5 Mar 2007, Eric Dumazet wrote:

> Davide Libenzi a =E9crit :
> > ChangeLog:
> >=20
> > v2) In v1, I was trying to avoid to get the spinlock twice WRT yesterda=
y
> > patch, but it turns out I can't since the ready list will be travelling
> > through a path w/out the ep->sem held. Oh well...
> >=20
> >=20
>=20
> What about the epitem->revents that we agreed to suppress ?
>=20
> Me confused...

Me and Pine too :)
Of course revents is gone, posted wrong thing. Damn it!



- Davide


--1795850513-2052709138-1173131050=:4907--
