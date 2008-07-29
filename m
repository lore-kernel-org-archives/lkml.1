Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYG2HNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYG2HNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 03:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYG2HM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 03:12:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49983
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751034AbYG2HM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 03:12:59 -0400
Date: Tue, 29 Jul 2008 00:12:56 -0700 (PDT)
Message-Id: <20080729.001256.203097603.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sparc64: build failure at sys_sparc32.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080729065914.GA30878@orion>
References: <20080729065914.GA30878@orion>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Tue, 29 Jul 2008 10:59:14 +0400

> I am testing build using randconfig.
> 
> arch/sparc64/kernel/sys_sparc32.c: In function 'sys32_chown16':
> arch/sparc64/kernel/sys_sparc32.c:63: error: implicit declaration of
> function 'low2highuid'
> arch/sparc64/kernel/sys_sparc32.c:63: error: implicit declaration of
> function 'low2highgid'
> arch/sparc64/kernel/sys_sparc32.c: In function 'sys32_getresuid16':
> arch/sparc64/kernel/sys_sparc32.c:106: error: implicit declaration of
> function 'high2lowuid'
> arch/sparc64/kernel/sys_sparc32.c: In function 'sys32_getresgid16':
> arch/sparc64/kernel/sys_sparc32.c:123: error: implicit declaration of
> function 'high2lowgid'
> 
> These functions are defined in linux/highuid.h only if CONFIG_UID16 is enabled.

Thanks, what kernel version is this?
