Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbXKAEOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbXKAEOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 00:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbXKAEOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 00:14:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:42013 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751835AbXKAEOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 00:14:38 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX1/tiQENe+vtrfBD92ve1eT7hxbqfZrWoiLkTN2C/p
	ZrHkWz8yK3UwZV
From: Jan-Simon =?utf-8?q?M=C3=B6ller?= <dl9pf@gmx.de>
To: linux-kernel@vger.kernel.org, dl9pf@gmx.de
Subject: kbuild: modules_install regression ? - depmod
Date: Thu, 1 Nov 2007 05:14:34 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711010514.34469.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I compiled kernel 2.6.24-rc1 (latest git as of today) on a Box with 256MB Ram.
During "make modules_install" I got these errors:

  DEPMOD  2.6.24-rc1-default
WARNING: Can't read 
module /lib/modules/2.6.24-rc1-default/kernel/net/bridge/bridge.ko: Cannot 
allocate memory
WARNING: Can't read 
module /lib/modules/2.6.24-rc1-default/kernel/net/bridge/netfilter/ebt_redirect.ko: 
Cannot allocate memory
[...]
FATAL: Memory allocation failure depmod.c line 158: realloc(mod->deps, 
sizeof(mod->deps[0])*(mod->num_deps+1)).
make: *** [_modinst_post] Fehler 1


Depmod used too much memory and exits. Tried a 2nd time and checked with top.

IMHO this is a regression.

best regards
jan-simon
