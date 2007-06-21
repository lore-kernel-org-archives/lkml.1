Return-Path: <linux-kernel-owner+w=401wt.eu-S1759155AbXFUR0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155AbXFUR0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028AbXFUR0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:26:16 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:53519 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755892AbXFUR0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:26:15 -0400
Date: Thu, 21 Jun 2007 19:25:57 +0200
From: Alexander Wuerstlein <snalwuer@cip.informatik.uni-erlangen.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alexander Wuerstlein <arw@arw.name>, linux-kernel@vger.kernel.org,
       Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>
Subject: Re: [PATCH] Check files' signatures before doing suid/sgid [2/4]
Message-ID: <20070621172557.GE9741@cip.informatik.uni-erlangen.de>
References: <11824417551424-git-send-email-arw@arw.name> <1182446251.2704.0.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182446251.2704.0.camel@laptopd505.fenrus.org>
X-Echelon-Scan: plutonium bomb dirty irak allah satan bush victory c4
	cocaine saddam wtc holy war believe god cia nsa
X-Echelon-Result: Terrorist
User-Agent: Mutt/1.5.15 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 070621 19:21, Arjan van de Ven <arjan@infradead.org> wrote:
> On Thu, 2007-06-21 at 18:02 +0200, Alexander Wuerstlein wrote:
> > Modified task_struct to hold a 'signed flag' which is set on exec(), inherited
> > on fork() and checked during exec before giving the new process suid/sgid
> > privileges.
> > 
> 
> 
> 
> do you also check the signature of glibc and every other shared library
> that the app uses (or dlopens)? if not.. the entire exercise is rather
> pointless...

We do check that, that is patch [3/4].

Of course we can only check mmap-ed files, if there is no file like with JIT
compilers we are out of luck.


Ciao,

Alexander Wuerstlein.
