Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbYHASRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbYHASRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYHASRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:17:38 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33865 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYHASRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:17:37 -0400
Date: Fri, 1 Aug 2008 11:14:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh <greg@kroah.com>
Subject: Re: linux-next: Tree for August 1 (sysfs.h)
Message-Id: <20080801111452.1b4c55d3.randy.dunlap@oracle.com>
In-Reply-To: <20080801165808.68f833ec.sfr@canb.auug.org.au>
References: <20080801165808.68f833ec.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_SYSFS=n:

  CC      arch/x86/kernel/asm-offsets.s
In file included from linux-next-20080801/include/linux/kobject.h:21,
                 from linux-next-20080801/include/linux/module.h:16,
                 from linux-next-20080801/include/linux/crypto.h:21,
                 from linux-next-20080801/arch/x86/kernel/asm-offsets_64.c:7,
                 from linux-next-20080801/arch/x86/kernel/asm-offsets.c:4:
linux-next-20080801/include/linux/sysfs.h:247: error: return type is an incomplete type
linux-next-20080801/include/linux/sysfs.h: In function 'sysfs_get':
linux-next-20080801/include/linux/sysfs.h:248: warning: 'return' with a value, in function returning void
make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1




---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
