Return-Path: <linux-kernel-owner+w=401wt.eu-S965730AbXEDIXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965730AbXEDIXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767733AbXEDIXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:23:55 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:59345 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965730AbXEDIXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:23:54 -0400
X-Originating-Ip: 72.143.66.196
Date: Fri, 4 May 2007 04:23:36 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: "KERNEL/_KERNEL/INKERNEL" macro cruft
Message-ID: <Pine.LNX.4.64.0705040415360.22553@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  can any of this be removed?  for a start, what's the point of
"#define KERNEL"?

$ grep -r "^#define KERNEL$" *
drivers/net/skfp/srf.c:#define KERNEL
drivers/net/skfp/pmf.c:#define KERNEL
drivers/net/skfp/smt.c:#define KERNEL
drivers/net/skfp/ecm.c:#define KERNEL
drivers/net/skfp/pcmplc.c:#define KERNEL
drivers/net/skfp/cfm.c:#define KERNEL
drivers/net/skfp/rmt.c:#define KERNEL
drivers/char/dtlk.c:#define KERNEL

  which seems unrelated to this:

$ grep -r "#if.* KERNEL$" *
include/linux/coda.h:#ifdef KERNEL

  and there's these lonely examples of "INKERNEL" and "_KERNEL":

$ grep -rw _KERNEL *
include/linux/coda.h:/* Catch new _KERNEL defn for NetBSD and DJGPP/__CYGWIN32__ */
include/linux/soundcard.h:#if (!defined(__KERNEL__) && !defined(KERNEL) && !defined(INKERNEL) && !defined(_KERNEL)) || defined(USE_SEQ_MACROS)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
