Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbXDWViW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbXDWViW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbXDWViW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:38:22 -0400
Received: from web88101.mail.re2.yahoo.com ([206.190.37.202]:25993 "HELO
	web88101.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754274AbXDWViW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:38:22 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Apr 2007 17:38:21 EDT
X-YMail-OSG: eP9e2FQVM1nzq2is2Du2aUf3xYBggucL8Xe.xI8ecyS5lCO5IBhcRmNTO2UD7NSAGy7ShvLUwikFPZH3Qat2OsE03w--
X-Mailer: YahooMailRC/478 YahooMailWebService/0.7.41.10
Date: Mon, 23 Apr 2007 14:31:39 -0700 (PDT)
From: Matt Ranon <mranon@javadevices.com>
Subject: [ANNOUNCE][PATCH] Kcli - Kernel command line interface.
To: linux maillist <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <875184.9239.qm@web88101.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Jem team is pleased to announce the release of Kcli, an in-kernel command line interface. Kcli is intended for a special class of embedded Linux applications. The Linux kernel has become the defacto standard OS for embedded applications. This means that Linux is getting bent in some ways that may appear strange to some. One of these ways, is embedded applications that do not use user space. User space consists of a statically linked, one line program, that simply sleeps forever, transforming Linux into a classical embedded RTOS. VxWorks developers will understand what we are talking about, and they may recall how much they depend on the VxWorks shell. Kcli attempts to meet the need for a shell for this class of embedded Linux applications. 
 
Kcli provides a command line environment that runs in the kernel, and that can be extended with custom commands registered by other kernel modules. We have found Kcli invaluable for our development, and we are releasing the patch, in case others find it useful.
 
Kcli is directly derived from libcli written by David Parrish and Brendan O'Dea, and the regular expression support is directly derived from diet libc written by Felix von Leitner.
 
The Jem team fully understands that this kind of patch may not be appropriate for inclusion in the mainline kernel code. We have no expectation that it will be, and we leave that decision fully in the hands of those responsible. Nonetheless, we feel that others may find it useful, and we will also appreciate any appropriate feedback from the community.
 
Kcli is standalone, and modifies no kernel files, except for the Kconfig and Makefile modifications required to wire it into the configuration and build.
 
The Kcli patch is available at ftp://www.javadevices.com/kcli/kcli-v1_0_0.patch.
 
MRanon
