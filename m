Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZASQlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZASQlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 11:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbZASQlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 11:41:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37100 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbZASQlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 11:41:15 -0500
Date: Mon, 19 Jan 2009 14:40:29 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kmemtrace: kbuild failed to make the new header symlink...
Message-ID: <20090119164029.GB19302@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

	I just did a git pull on linux-2.6-tip, then, on a build
directory (make O=../build/blkftrace/) with a previous build a tree
cloned from Linus I got stuck with the messages below.

	I could only get this to work after a make mrproper, thought I
could mention this so that perhaps this can get detected and time be
saved somehow.

  CC      arch/x86/mm/fault.o
/home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:38:27: error: asm/kmemcheck.h: No such file or directory
/home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c: In function ‘do_page_fault’:
/home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:614: error: implicit declaration of function ‘kmemcheck_active’
/home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:615: error: implicit declaration of function ‘kmemcheck_hide’
/home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:644: error: implicit declaration of function ‘kmemcheck_fault’

- Arnaldo
