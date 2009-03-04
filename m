Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbZCDU2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbZCDU2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbZCDU17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:27:59 -0500
Received: from sorrow.cyrius.com ([65.19.161.204]:45711 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbZCDU16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:27:58 -0500
Date: Wed, 4 Mar 2009 21:27:46 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org
Subject: "x86-64: seccomp: fix 32/64 syscall hole" breaks mips
Message-ID: <20090304202746.GA28981@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change "x86-64: seccomp: fix 32/64 syscall hole" breaks compilation on
MIPS (and possibly other architectures):

/home/tbm/kernel/linux-2.6-2.6.29~rc7/debian/build/source_mips_none/kernel/seccomp.c: In function ‘__secure_computing’:
/home/tbm/kernel/linux-2.6-2.6.29~rc7/debian/build/source_mips_none/kernel/seccomp.c:42: error: implicit declaration of function ‘is_compat_task’
make[6]: *** [kernel/seccomp.o] Error 1

-- 
Martin Michlmayr
http://www.cyrius.com/
