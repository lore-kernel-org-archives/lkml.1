Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYHBVMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYHBVMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 17:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYHBVMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 17:12:14 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:47935 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751627AbYHBVMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 17:12:13 -0400
Date: Sat, 2 Aug 2008 23:16:12 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Calvin Walton <calvin.walton@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       7eggert@gmx.de
Subject: Re: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately 
 unselectable.
In-Reply-To: <10758824.1217687776711.JavaMail.oracle@acsmt303.oracle.com>
Message-ID: <alpine.LSU.0.999.0808022214460.4469@be1.lrz>
References: <aTS0O-4U1-33@gated-at.bofh.it> <aTV89-39s-5@gated-at.bofh.it>
 <aTZYh-4i3-21@gated-at.bofh.it> <aUrrl-78m-3@gated-at.bofh.it>
 <aUxwQ-1Hn-19@gated-at.bofh.it> <aUERB-Zl-5@gated-at.bofh.it>
 <aUFXh-3m9-3@gated-at.bofh.it> <aUJ4U-1xe-19@gated-at.bofh.it>
 <aUJeD-1N6-13@gated-at.bofh.it> <aUUME-5MM-11@gated-at.bofh.it>
 <aV05W-1wO-41@gated-at.bofh.it> <E1KPGQ3-0001T9-RS@be1.7eggert.dyndns.org>
 <10758824.1217687776711.JavaMail.oracle@acsmt303.oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Aug 2008, Randy Dunlap wrote:
> --- Original Message ---
> > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > I don't see the "if PARTITION_ADVANCED" block as being compatible with the
> > > need to have default partition types per $ARCH.
> > > Do you see some way around that problem?
> > 
> > You need menuconfig_usedefaults.
> 
> Where is that?

Currently nowhere, it's just my idea of how to solve the problem.
It would be a variant of KConfig's menuconfig option, having the desired
behaviour.

Unfortunately I don't have time to implement that, especially since I don't 
know that part of the code. The last few weeks, I was barely able to
assemble my new desk.
-- 
To define recursion, we must first define recursion.
