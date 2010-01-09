Return-Path: <linux-kernel-owner+w=401wt.eu-S1752098Ab0AIIvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab0AIIvS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 03:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857Ab0AIIvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 03:51:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39564 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0AIIvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 03:51:16 -0500
Date: Sat, 9 Jan 2010 09:51:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: trouble compiling dwalker's for-next tree
Message-ID: <20100109085106.GA23290@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

It is great to have all changes merged, but I ran into some trouble:

1) mmc.h was missing.

2)   CC      arch/arm/mach-msm/rpc_hsusb.o
arch/arm/mach-msm/rpc_hsusb.c: In function 'msm_chg_rpc_connect':
arch/arm/mach-msm/rpc_hsusb.c:156: error: implicit declaration of
function 'machine_is_msm7201a_surf'
arch/arm/mach-msm/rpc_hsusb.c:156: error: implicit declaration of
function 'machine_is_msm7x27_surf'
arch/arm/mach-msm/rpc_hsusb.c:157: error: implicit declaration of
function 'machine_is_qsd8x50_surf'
make[1]: *** [arch/arm/mach-msm/rpc_hsusb.o] Error 1

(I provided missing inlines)

3)   CC      arch/arm/mach-msm/acpuclock.o
arch/arm/mach-msm/acpuclock.c:31:35: error: linux/remote_spinlock.h:
No such file or directory
arch/arm/mach-msm/acpuclock.c:106: error: expected '=', ',', ';',
'asm' or '__attribute__' before 'pll_lock'

(I'm currently stuck here).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
