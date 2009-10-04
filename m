Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbZJDWiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbZJDWiK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 18:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbZJDWiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 18:38:09 -0400
Received: from ara.aytolacoruna.es ([91.117.124.165]:51317 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbZJDWiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 18:38:08 -0400
Date: Mon, 5 Oct 2009 00:37:05 +0200
From: Santiago Garcia Mantinan <manty@manty.net>
To: Santiago Garcia Mantinan <manty@manty.net>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: kernel BUG at drivers/ide/ide-disk.c:187 (2.6.31)
Message-ID: <20091004223705.GB5030@dis.manty.net>
References: <20090930110529.GA3676@dis.manty.net>
 <20091001.114755.132624639.davem@davemloft.net>
 <20091001.115310.100974682.davem@davemloft.net>
 <20091003033942.GA8129@dis.manty.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091003033942.GA8129@dis.manty.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Applied it to 2.6.31.1, I'll wait and see what the weekend tells us.

up 2 days,  8:27 and still nothing, maybe I shouldn't have applied it to .1
as some of the fixes there could be masking the problem and I should be
testing it on 2.6.31 :-?

What do you think about, that, should I compile a plain 2.6.31? or should I
give 2.6.31.1 some more time?

On the other hand when I tried to compile a kernel for a non IDE machine out
of the same 2.6.31.1 patched sources I found this error:

ERROR: "ide_kill_rq" [drivers/ide/ide-gd_mod.ko] undefined!
make[2]: *** [__modpost] Erro 1
make[1]: *** [modules] Erro 2
make[1]: Saíndo do directorio `/usr/src/linux-2.6.31'

After reverting the patch it compiled ok, of course, I was wondering if this
only affects the modules build and for the test we are having I have IDE in
the kernel, so no problem with that, or if that can affect the IDE kernel as
well and it may break because of the patch or something.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
