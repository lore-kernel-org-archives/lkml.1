Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbZL2TUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbZL2TUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 14:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbZL2TUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 14:20:05 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:47038 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbZL2TUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 14:20:01 -0500
Date: Tue, 29 Dec 2009 14:19:30 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: what's the purpose of MAXHOSTNAMELEN?
Message-ID: <alpine.LFD.2.00.0912291416230.4967@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  in prepping for coalescing a lot of param.h files, i'm curious about
the purpose of this macro:

$ grep -rw MAXHOSTNAMELEN *
arch/s390/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
arch/sparc/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
arch/alpha/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
arch/mn10300/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
arch/arm/include/asm/param.h:#define MAXHOSTNAMELEN  64
arch/m32r/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
arch/mips/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
arch/m68k/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
arch/xtensa/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
arch/ia64/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
arch/h8300/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
arch/avr32/include/asm/param.h:#define MAXHOSTNAMELEN	64
arch/cris/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
arch/um/include/asm/param.h:#define MAXHOSTNAMELEN  64      /* max length of hostname */
arch/powerpc/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
arch/parisc/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
arch/frv/include/asm/param.h:#define MAXHOSTNAMELEN		64	/* max length of hostname */
include/asm-generic/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
include/net/sctp/structs.h:#include <asm/param.h>		/* We get MAXHOSTNAMELEN.     */
$

  so lots of people define it but no one uses it.  it *is* exported to
user space in /usr/include/asm/param.h, but i still have no idea what
it's for in user space.  obsolete?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
