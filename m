Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbZEaOCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbZEaOCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbZEaOCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:02:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63547 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbZEaOCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:02:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 0/14] score - New architecure port to SunplusCT S+CORE
Date: Sun, 31 May 2009 14:00:58 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <OFBE107210.5CC63061-ON482575C7.00354DAD-482575C7.00372848@sunplusct.com>
In-Reply-To: <OFBE107210.5CC63061-ON482575C7.00354DAD-482575C7.00372848@sunplusct.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905311400.58509.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19GblK5BiUi9OvreS7/3NxHcNrBanNhFob6wJC
 JF12dTs3+u80jnwZS9CroQuVXc1Sa4Vpw182aazkV7s/FKlBLg
 ay9FMbmM3p7W/Hxseb2tg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 May 2009 09:58:28 liqin.chen@sunplusct.com wrote:
> Hi Arnd,
> 
> > Have you had a chance to look at the asm-generic header files I posted
> > a few times?
> > 
> > ...
> > Please tell me if you find problems in the generic header files during
> > the conversion.
> > 
> 
> I can't clone the linux/kernel/git/arnd/asm-generic.git repository, 
> and have not test score arch code until now.

Hmm, what is the error message you get? It works fine here:

arnd@wuerfel:/tmp$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
Initialized empty Git repository in /tmp/asm-generic/.git/
remote: Counting objects: 1180676, done.
remote: Compressing objects: 100% (189568/189568), done.
remote: Total 1180676 (delta 984963), reused 1179831 (delta 984290)
Receiving objects: 100% (1180676/1180676), 288.80 MiB | 1308 KiB/s, done.
Resolving deltas: 100% (984963/984963), done.
Checking out files: 100% (27918/27918), done.
arnd@wuerfel:/tmp$ cd asm-generic/
arnd@wuerfel:/tmp/asm-generic$ git checkout -b next origin/next
Branch next set up to track remote branch refs/remotes/origin/next.
Switched to a new branch "next"

> In addition, next time I send the patches mail should base on
> linux/kernel/git/arnd/asm-generic.git or
> linux/kernel/git/sfr/linux-next.git?

Feel free to base you code on top of asm-generic.git#next, but tell me
when you intend to do that so I can warn you of possibly rebases.

The easiest way for you to merge code would be if you can arrange to have
a git account on kernel.org (see http://www.kernel.org/faq/#account), on
your company web server, or on a free hosting service like github.com
or gitorious.org.

Your patches or git tree should merge fine with the linux-next tree so
that Stephen can pick them up as early as possibly, but in general they
should not be _based_ on linux-next because that would mean that
Linus needs to pull all of linux-next in order to merge your code.

	Arnd <><
