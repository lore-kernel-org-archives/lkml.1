Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYEGVHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYEGVHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYEGVHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:07:33 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:60667 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbYEGVHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:07:31 -0400
Message-ID: <48221A45.8060602@henry.ne.arcor.de>
Date: Wed, 07 May 2008 23:08:21 +0200
From: Henry Nestler <Henry.Ne@Arcor.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Henry Nestler <henry.nestler@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: endless page faults in mount_block_root for Linux
 2.6 - v2
References: <480E6BB4.5080902@henry.nestler.gmail.com> <20080428164455.GB18210@elte.hu> <48221695.7060507@henry.nestler.gmail.com>
In-Reply-To: <48221695.7060507@henry.nestler.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henry Nestler wrote:
> [...]
> checking if image is initramfs...it isn't (no cpio magic); looks like an
> initrd
> BUG: unable to handle kernel paging request at c0000e68
> IP: [<c010cb84>] __change_page_attr_set_clr+0x104/0x590
> *pde = 00000063 BUG: unable to handle kernel paging request at c0000000
> IP: [<c010c5c9>] do_page_fault+0x639/0x730
> *pde = 00000063 BUG: unable to handle kernel paging request at c0000000
> IP: [<c010c5c9>] do_page_fault+0x639/0x730
> *pde = 00000063 BUG: unable to handle kernel paging request at c0000000
> IP: [<c010c5c9>] do_page_fault+0x639/0x730
> ===== ... this never ends or with a stack overflow ... ===
> 
> Shure, the "out of range address" was from buggy driver development.
> But not of adresses should kill the complete system.
> 
> "__change_page_attr_set_clr" is some of the macros inside spurious_fault.

Sorry. Copy&paste error. I wand to say:
"do_page_fault+0x639/0x730" is one of the macros or inline functions
"pgd_present(*pgd)" or "pte_write(*pte)", what I can not see as label.

-- 
Henry N.
