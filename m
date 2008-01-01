Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbYAAToe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbYAAToe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 14:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYAAToZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 14:44:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37313 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbYAAToY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 14:44:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: build #341 failed for 2.6.24-rc6-g1842c7f in linux/./drivers/media/dvb/ttpci/budget-av.c
Date: Tue, 1 Jan 2008 20:45:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
References: <200712291617.01533.toralf.foerster@gmx.de>
In-Reply-To: <200712291617.01533.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801012045.54279.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 29 of December 2007, Toralf Förster wrote:
> Hello,
> 
> the build with the attached .config failed, make ends with:
> ...
> drivers/built-in.o: In function `ttpci_budget_deinit':
> (.text+0x9d24d): undefined reference to `saa7146_vfree_destroy_pgtable'
> drivers/built-in.o: In function `ttpci_budget_debiread':
> (.text+0x9d479): undefined reference to `saa7146_wait_for_debi_done'
> drivers/built-in.o: In function `ttpci_budget_debiread':
> (.text+0x9d4c9): undefined reference to `saa7146_wait_for_debi_done'
> drivers/built-in.o: In function `ttpci_budget_debiwrite':
> (.text+0x9d543): undefined reference to `saa7146_wait_for_debi_done'
> drivers/built-in.o: In function `ttpci_budget_debiwrite':
> (.text+0x9d597): undefined reference to `saa7146_wait_for_debi_done'
> drivers/built-in.o: In function `ttpci_budget_debiwrite':
> (.text+0x9d5bb): undefined reference to `saa7146_wait_for_debi_done'
> drivers/built-in.o: In function `ttpci_budget_init':
> (.text+0x9d7be): undefined reference to `saa7146_i2c_adapter_prepare'
> drivers/built-in.o: In function `ttpci_budget_init':
> (.text+0x9d80e): undefined reference to `saa7146_vmalloc_build_pgtable'
> drivers/built-in.o: In function `ttpci_budget_init':
> (.text+0x9d860): undefined reference to `saa7146_setgpio'
> drivers/built-in.o: In function `ttpci_budget_init':
> (.text+0x9d952): undefined reference to `saa7146_vfree_destroy_pgtable'
> drivers/built-in.o: In function `budget_av_detach':
> budget-av.c:(.text+0x9dbcf): undefined reference to `saa7146_setgpio'
> budget-av.c:(.text+0x9dc0d): undefined reference to `saa7146_setgpio'
> budget-av.c:(.text+0x9dc1b): undefined reference to `saa7146_setgpio'
> budget-av.c:(.text+0x9dc29): undefined reference to `saa7146_setgpio'
> budget-av.c:(.text+0x9dc37): undefined reference to `saa7146_setgpio'
> drivers/built-in.o:budget-av.c:(.text+0x9e4d1): more undefined references to `saa7146_setgpio' follow
> drivers/built-in.o: In function `budget_av_init':
> budget-av.c:(.init.text+0x5bd6): undefined reference to `saa7146_register_extension'
> drivers/built-in.o: In function `budget_av_exit':
> budget-av.c:(.exit.text+0x636): undefined reference to `saa7146_unregister_extension'
> make: *** [.tmp_vmlinux1] Error 1
> 
> The build was made with :
> $> make mrproper && make rndconfig && <tweak config file> && make oldconfig && make

I've created Bugzilla entry for this issue at:
http://bugzilla.kernel.org/show_bug.cgi?id=9671
and added it to the list of known regressions.

Thanks,
Rafael
