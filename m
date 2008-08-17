Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYHQR3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYHQR3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYHQR2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:28:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40817 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbYHQR2z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:28:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: 2.6.27-rc3-git4: Multiple implicit declarations in log2.h
Date: Sun, 17 Aug 2008 19:32:20 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808171932.21337.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see this compiling the current mainline on x86-64:

  AS      arch/x86/boot/compressed/head_64.o
In file included from /home/rafael/src/linux-2.6/include/linux/kernel.h:16,
                 from /home/rafael/src/linux-2.6/arch/x86/boot/memory.c:16:
/home/rafael/src/linux-2.6/include/linux/log2.h: In function ‘__ilog2_u32’:
/home/rafael/src/linux-2.6/include/linux/log2.h:34: warning: implicit declaration of function ‘fls’
/home/rafael/src/linux-2.6/include/linux/log2.h: In function ‘__ilog2_u64’:
/home/rafael/src/linux-2.6/include/linux/log2.h:42: warning: implicit declaration of function ‘fls64’
/home/rafael/src/linux-2.6/include/linux/log2.h: In function ‘__roundup_pow_of_two’:
/home/rafael/src/linux-2.6/include/linux/log2.h:63: warning: implicit declaration of function ‘fls_long’
  CC      arch/x86/boot/compressed/misc.o

I guess there's a missing #include or something?

Rafael
