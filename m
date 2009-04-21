Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbZDUHqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbZDUHqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZDUHpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:45:53 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45378 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbZDUHpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:45:52 -0400
Message-ID: <49ED79AB.10004@petalogix.com>
Date: Tue, 21 Apr 2009 09:45:47 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Microblaze noMMU/MMU merge
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I would like to say your opinion about putting together Microblaze MMU
arch to noMMU version.

In C code will be #ifdef CONFIG_MMU ... #endif  or #ifndef.

Here is proposal for headers. The similar style is used in m68k but I
would like to have the same code
for both archs in main file.

#ifndef _ASM_MICROBLAZE_PAGE_H
#define _ASM_MICROBLAZE_PAGE_H

code for noMMU and MMU which is the same for both.

#ifdef __uClinux__
#include "page_no.h" -> noMMU specific
#else
#include "page_mm.h"-> MMU specific
#endif
#endif /* _ASM_MICROBLAZE_PAGE_H */


Thanks for your suggestion,
Michal



-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

