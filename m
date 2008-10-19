Return-Path: <linux-kernel-owner+w=401wt.eu-S1752329AbYJSVbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbYJSVbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 17:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYJSVbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 17:31:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:49372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbYJSVbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 17:31:11 -0400
Date: Sun, 19 Oct 2008 21:31:07 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.36.8
Message-ID: <20081019213107.GA20481@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 19 Oct 2008 21:31:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.36.8.

It contains various fixes, 3 of which are for medium local security
issues. While not critical, it is suggested that 2.4.36 setups with
untrusted local users upgrade to 2.4.36.8.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.36.8.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.36.8

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.36.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.36.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.36.y.git


Willy

---
Summary of changes from v2.4.36.7 to v2.4.36.8
============================================

Arjan van de Ven (1):
      security: avoid calling a NULL function pointer in drivers/video/tvaudio.c

Erik Inge Bolsø (1):
      doc: mention chain-compiling for really old gccs

Eugene Teo (2):
      CVE-2008-3275 Linux kernel local filesystem DoS
      Remove suid/sgid bits on truncate() (CVE-2008-4210)

Gilles Espinasse (1):
      tcp: Clear probes_out more aggressively in tcp_ack().

Willy Tarreau (4):
      x86 would not build without CONFIG_VT
      pc_keyb: fix breakage on ia64/mips/mips64
      doc: fix examples and add suggestions about depmod
      Change VERSION to 2.4.36.8

Yasuyuki KOZAKAI (1):
      netfilter: ip6t_{hbh,dst}: Rejects not-strict mode on rule insertion

