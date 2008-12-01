Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYLATHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYLATHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 14:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYLATHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 14:07:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49127 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbYLATHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 14:07:17 -0500
Date: Mon, 1 Dec 2008 17:07:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Toralf =?ISO-8859-1?B?RvZyc3Rlcg==?= <toralf.foerster@gmx.de>
Cc: liplianin@me.by, linux-kernel@vger.kernel.org
Subject: Re: build issue #577 for v2.6.28-rc6-184-gd9d060a :undefined
 reference to `cx24116_attach'
Message-ID: <20081201170701.78be454f@pedra.chehab.org>
In-Reply-To: <200812011947.37381.toralf.foerster@gmx.de>
References: <200812011947.37381.toralf.foerster@gmx.de>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toralf,

On Mon, 1 Dec 2008 19:47:33 +0100
Toralf Förster <toralf.foerster@gmx.de> wrote:

> Hello,
> 
> the build (.config attached) failed, make ends with :
> ...
>   AR      arch/x86/lib/lib.a
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: modpost: Found 2 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `frontend_init':
> /home/tfoerste/devel/linux-2.6/drivers/media/dvb/dm1105/dm1105.c:664: 
> undefined reference to `cx24116_attach'
> make: *** [.tmp_vmlinux1] Error 1

I have a fix for this already on my tree. I'll forward later today for upstream addition.

-- 

Cheers,
Mauro
