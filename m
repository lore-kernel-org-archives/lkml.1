Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbZKHPhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbZKHPhv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZKHPhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:37:50 -0500
Received: from borg.medozas.de ([188.40.89.202]:48508 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbZKHPhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:37:50 -0500
Date: Sun, 8 Nov 2009 16:37:54 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 01/12] vsprintf: factorize "(null)" string
In-Reply-To: <643e6260a571b533d8985b377a82410aded4ddae.1257602781.git.andre.goddard@gmail.com>
Message-ID: <alpine.LSU.2.00.0911081630180.26458@obet.zrqbmnf.qr>
References: <cover.1257602781.git.andre.goddard@gmail.com> <643e6260a571b533d8985b377a82410aded4ddae.1257602781.git.andre.goddard@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stripping the humongous Cc list for sanity.


On Saturday 2009-11-07 16:16, André Goddard Rosa wrote:

>Change "<NULL>" to "(null)" and make it a static const char[] hoping that
>the compiler will make null_str a label to a read-only area containing it.

Hoping? Nah, thanks.

>See:
>http://udrepper.livejournal.com/13851.html

Ulrich's example already _has_ a variable that is then changed from 
const char * to const char[]. Of course doing that will save you the 
extra pointer.

But vsprintf.c on the other hand did not have that extra variable to 
begin with! But it is ok nevertheless, and the unification of <NULL> vs 
(null) is worthwhile.
