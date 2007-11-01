Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbXKABjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbXKABjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 21:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbXKABjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 21:39:06 -0400
Received: from xenotime.net ([66.160.160.81]:38013 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753022AbXKABjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 21:39:05 -0400
Date: Wed, 31 Oct 2007 18:39:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: sam@ravnborg.org, linux-kbuild@vger.kernel.org
Subject: kbuild problem
Message-Id: <20071031183900.46a0b529.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

I have daily/nightly builds + test runs that use something like:
(but more complicated than this)

cp saved.config.file arch/$ARCH/config.default
EXPORT KBUILD_DEFCONFIG=config.default
make defconfig


This stopped working in 2.6.24-rc1-git3.  git2 worked as (I) expected.

Is there anything in the Makefile changes around that time
that could have caused this?

Note: the make defconfig output has changed from

Default configuration is based on config.default

to

*** Default configuration is based on 'x86_64_defconfig'


If not, I'll dig deeper into my script files.

Thanks,
---
~Randy
