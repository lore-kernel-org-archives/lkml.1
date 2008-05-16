Return-Path: <linux-kernel-owner+w=401wt.eu-S1760481AbYEPPgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481AbYEPPgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbYEPPgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:36:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57818 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYEPPgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:36:39 -0400
Date: Fri, 16 May 2008 17:36:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Junjiro Okajima <hooanon05@yahoo.co.jp>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/67] aufs module global variables and operations
In-Reply-To: <1210948401506-git-send-email-hooanon05@yahoo.co.jp>
Message-ID: <alpine.LNX.1.10.0805161734370.15590@fbirervta.pbzchgretzou.qr>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp>
 <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-05-16 16:32, hooanon05@yahoo.co.jp wrote:
>+/* ---------------------------------------------------------------------- */
>+
>+/* fake Kconfig */

I doubt this is needed anymore:

>+#if 1
>+
>+#ifdef CONFIG_AUFS_HINOTIFY
>+#ifndef CONFIG_INOTIFY
>+#error enable CONFIG_INOTIFY to use CONFIG_AUFS_HINOTIFY.
>+#endif
>+#endif /* CONFIG_AUFS_HINOTIFY */
>+
>+#if AUFS_BRANCH_MAX > 511 && PAGE_SIZE > 4096
>+#warning pagesize is larger than 4kb, \
>+	CONFIG_AUFS_BRANCH_MAX_511 or smaller is recommended.
>+#endif
>+
>+#ifdef CONFIG_AUFS_STAT
>+#ifndef CONFIG_SYSFS
>+#error CONFIG_AUFS_STAT requires CONFIG_SYSFS.
>+#endif
>+#endif /* CONFIG_AUFS_STAT */
>+
>+#ifdef CONFIG_AUFS_SYSAUFS
>+#warning CONFIG_AUFS_SYSAUFS is unnecessary for linux-2.6.25 and later.
>+#endif
>+
>+#ifdef CONFIG_AUFS_EXPORT
>+#if !defined(CONFIG_EXPORTFS) && !defined(CONFIG_EXPORTFS_MODULE)
>+#error CONFIG_AUFS_EXPORT requires CONFIG_EXPORTFS
>+#endif
>+#if defined(CONFIG_EXPORTFS_MODULE) && defined(CONFIG_AUFS)
>+#error need CONFIG_EXPORTFS = y to link aufs statically with CONFIG_AUFS_EXPORT
>+#endif
>+#endif /* CONFIG_AUFS_EXPORT */
>+
...

