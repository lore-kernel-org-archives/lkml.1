Return-Path: <linux-kernel-owner+w=401wt.eu-S934963AbXGUWMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934963AbXGUWMi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935134AbXGUWL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:11:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:22370 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935552AbXGUWL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:11:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=nlvSZZqx8pdo+RO0tR2GwhiRXpElIrQsa0BC9t8iHlmCd0DmDclukFdX9Tbogg0CYnTwCC67ZMNJE+G/Dyt6Anksry+FMaxFNcHCl64r/mWNuZaIh9O1gFlSJtPGofQiTZ5CFCDExNt84bf8dt3s+u+E2PHI6ILaZm8EwqCK+p8=
Message-ID: <46A282B2.8070501@googlemail.com>
Date: Sun, 22 Jul 2007 00:03:30 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: voyager_{thread,cat}.c compile warnings
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed this warnings on current git:


...

arch/i386/mach-voyager/voyager_thread.c: In function 'thread':
arch/i386/mach-voyager/voyager_thread.c:113: warning: no return statement in function returning non-void

...

I think return 0; is missing on line 112 here.


...

arch/i386/mach-voyager/voyager_cat.c: In function 'voyager_cat_init':
arch/i386/mach-voyager/voyager_cat.c:685: warning: comparison is always false due to limited range of data type
arch/i386/mach-voyager/voyager_cat.c:755: warning: comparison is always false due to limited range of data type

...


Regards,

Gabriel C

