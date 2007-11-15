Return-Path: <linux-kernel-owner+w=401wt.eu-S932552AbXKOUQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbXKOUQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbXKOUQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:16:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbXKOUQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:16:44 -0500
Message-ID: <473CA729.5010906@redhat.com>
Date: Thu, 15 Nov 2007 12:08:09 -0800
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Frederik Deweerdt <deweerdt@free.fr>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv2 2/4] x86&x86-64 support for sys_indirect
References: <200711151822.lAFIMVvW028590@devserv.devel.redhat.com> <20071115192947.GF1299@slug>
In-Reply-To: <20071115192947.GF1299@slug>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Frederik Deweerdt wrote:
\>> +     sys_call_table[INDIRECT_SYSCALL(regs)->eax] ((regs)->ebx,
(regs)->ecx, \
>                                              ^^^^^-> I take it that ->eax is wrong here? 

Yep, my bad.  I've retired the 32-bit machines around here.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHPKcp2ijCOnn/RHQRAjqMAKCLra+KisV6inTbPrbLtqruDVKyxACgxRLf
kFDyFNbnhqyj3MUkmzV0S2o=
=HQcV
-----END PGP SIGNATURE-----
