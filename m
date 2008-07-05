Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYGESop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYGESop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 14:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYGESog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 14:44:36 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44550 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYGESog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 14:44:36 -0400
Date: Sat, 5 Jul 2008 20:44:35 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] checkpatch: complex macros need to ignore comments
In-Reply-To: <1214998278-11767-4-git-send-email-apw@shadowen.org>
Message-ID: <alpine.LNX.1.10.0807052043210.28765@fbirervta.pbzchgretzou.qr>
References: <1214998278-11767-1-git-send-email-apw@shadowen.org> <1214998278-11767-4-git-send-email-apw@shadowen.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-07-02 13:31, Andy Whitcroft wrote:

>Ensure we ignore comments in complex macro detection else we incorrectly
>report this:
>
>	#define PFM_GROUP_PERM_ANY     -1      /* any user/group */

Does it also catch this ugly piece from dcache.c?


#define DCACHE_NFSFS_RENAMED  0x0002    /* this dentry has been "silly
                                         * renamed" and has to be
                                         * deleted on the last dput()
                                         */

