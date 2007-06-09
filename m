Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbXFIL1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbXFIL1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 07:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbXFIL1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 07:27:02 -0400
Received: from wine.ocn.ne.jp ([220.111.47.146]:51724 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbXFIL1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 07:27:00 -0400
To: seanlkml@sympatico.ca
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading andmanipulation,pathname matching
From: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>
References: <20070609011022.ac332fc7.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706082224370.6675@asgard.lang.hm>
	<20070609014454.2f1f2f91.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706082356220.6675@asgard.lang.hm>
	<20070609032822.bc420a84.seanlkml@sympatico.ca>
In-Reply-To: <20070609032822.bc420a84.seanlkml@sympatico.ca>
Message-Id: <200706092026.CJH55869.NGPNtMTS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Sat, 9 Jun 2007 20:26:57 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sean wrote:
> All of a sudden you've implemented the main features of AA with very
> few changes to the kernel.  It should be more maintainable, and much
> easier to get accepted into the kernel.
Do you agree with passing "struct vfsmount" to VFS helper functions and LSM hooks
and introducing d_namespace_path() so that the AA extension can calculate the requested pathname
and map the requested pathname to SELinux's labels?
