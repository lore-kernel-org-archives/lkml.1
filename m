Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbZKHPot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbZKHPot (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZKHPot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:44:49 -0500
Received: from borg.medozas.de ([188.40.89.202]:48632 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbZKHPos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:44:48 -0500
Date: Sun, 8 Nov 2009 16:44:53 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 07/12] vsprintf: factor out skip_space code in a
 separate function
In-Reply-To: <7206ef594e67a240a842339f520284de6569b1fc.1257602781.git.andre.goddard@gmail.com>
Message-ID: <alpine.LSU.2.00.0911081644040.26458@obet.zrqbmnf.qr>
References: <cover.1257602781.git.andre.goddard@gmail.com> <7206ef594e67a240a842339f520284de6569b1fc.1257602781.git.andre.goddard@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2009-11-07 16:16, André Goddard Rosa wrote:

>It decreases code size:

And may increase runtime. If GCC determined that skip_space
itself (without the noinline you added) is going to be inlined,
let it go ahead.

>   text    data     bss     dec     hex filename
>  15719       0       8   15727    3d6f lib/vsprintf.o-before
>  15543       0       8   15551    3cbf lib/vsprintf.o-after
