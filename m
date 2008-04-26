Return-Path: <linux-kernel-owner+w=401wt.eu-S1759910AbYDZWlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910AbYDZWlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 18:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756816AbYDZWl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 18:41:29 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:51352 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbYDZWl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 18:41:28 -0400
Date: Sat, 26 Apr 2008 15:41:28 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       jakub@redhat.com, drepper@redhat.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
In-Reply-To: <517f3f820804240945l2dc203afx8fa432ac41219236@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0804261540310.6108@twinlark.arctic.org>
References: <20080424160352.30f2dd5b@the-village.bc.nu>  <20080424154441.GG2255@devserv.devel.redhat.com>  <20080424162444.1c5b9ba2@the-village.bc.nu>  <20080424.090008.232544945.davem@davemloft.net>  <20080424163835.55520b5b@the-village.bc.nu>
 <517f3f820804240945l2dc203afx8fa432ac41219236@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008, Michael Kerrisk wrote:

> A while back I did some testing of this point.  These were the results I noted:
> 
> FreeBSD 4.8
> O_NONBLOCK and O_ASYNC are inherited
> FD_CLOEXEC is not inherited
> 
> Solaris 8
> O_NONBLOCK and O_ASYNC are inherited
> FD_CLOEXEC is not inherited
> 
> Tru64 5.1 (sep 03, testdrive)
> No F_SETFL flags are inherited
> FD_CLOEXEC is not inherited
> 
> HP-UX 11
> No F_SETFL flags are inherited
> FD_CLOEXEC is not inherited

invent FD_CLOEXEC_INHERITED to handle accept()?

-dean
