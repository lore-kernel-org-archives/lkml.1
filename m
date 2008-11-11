Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbYKKGqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbYKKGqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYKKGqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:46:01 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39670 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbYKKGqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:46:00 -0500
Date: Tue, 11 Nov 2008 15:45:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 28-rc4-mmotm1110 build error with CONFIG_KEXEC=y
Message-Id: <20081111154520.f92c855d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <34270.1226373066@turing-police.cc.vt.edu>
References: <34270.1226373066@turing-police.cc.vt.edu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 22:11:06 -0500
Valdis.Kletnieks@vt.edu wrote:

> Build ka-blam number 1:
> 
>   CC      init/initramfs.o
> In file included from init/initramfs.c:542:
> include/linux/kexec.h:201: error: braced-group within expression allowed only inside a function
> include/linux/kexec.h:201: error: braced-group within expression allowed only inside a function
> include/linux/kexec.h:201: error: braced-group within expression allowed only inside a function
> include/linux/kexec.h:202: warning: type defaults to âintâ in declaration of âcrash_notesâ
> include/linux/kexec.h:203: error: braced-group within expression allowed only inside a function
> include/linux/kexec.h:203: error: braced-group within expression allowed only inside a function
> make[1]: *** [init/initramfs.o] Error 1
> make: *** [init] Error 2
> 
this is come from align-avoid-evaluating-its-argument-twice.patch


Thanks,
-Kame

