Return-Path: <linux-kernel-owner+w=401wt.eu-S1764227AbYDVPm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764227AbYDVPm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYDVPmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:42:17 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:33610 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbYDVPmR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:42:17 -0400
Date: Tue, 22 Apr 2008 11:42:16 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Message-ID: <20080422154216.GI19802@phobos.i.cabal.ca>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <20080422152122.GF19802@phobos.i.cabal.ca> <200804221738.19635.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200804221738.19635.arnd@arndb.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 05:38:19PM +0200, Arnd Bergmann wrote:
> On Tuesday 22 April 2008, Kyle McMartin wrote:
> > 
> > This should (imnsho, at least),
> >         1 - Add a cond_syscall for sys_sysfs to sys_ni.c
> >         2 - Use a CONFIG_EMBEDDED dependent option that defaults on,
> >             possibly depend on BLACKFIN if you really want to.
> > 
> > Adding this junk to every arch header is, in my opinion, completely
> > unacceptable just because blackfin wants to be different.
> 
> It's not that they want to be different, but rather that I (among others)
> requested that they don't implement obsolete syscalls, so they removed it
> from their syscall table.
> 

Ah, I stupidly assumed sys_sysfs was something to do with /sys.

regards, Kyle
