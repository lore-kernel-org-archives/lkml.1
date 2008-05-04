Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYEDK7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYEDK7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 06:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbYEDK7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 06:59:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:57492 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbYEDK7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 06:59:39 -0400
Date: Sun, 4 May 2008 12:59:37 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: LKML <linux-kernel@vger.kernel.org>
Subject: undefined reference to __udivdi3 (gcc-4.3)
Message-ID: <alpine.DEB.1.10.0805041251230.5391@sheep.housecafe.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX18UTfCRUiKHroRUU9kzzFpP7bxS9zsYctTyb9C
 UVGnkQrYc9HbSNRJiOkx+Xi8vC0QAMY7GjT9JSi6QpJ+jxrp7t
 e3Bu9j8n/FjjmS35CrZwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while trying to compile current -git or 2.6.25.1 with gcc (Debian 4.3.0-4) 
4.3.1 20080501 (prerelease), the following error occurs during linking:

arch/x86/xen/built-in.o: In function `xen_timer_interrupt':
time.c:(.text+0x2992): undefined reference to `__udivdi3'
time.c:(.text+0x2a13): undefined reference to `__udivdi3'
make: *** [.tmp_vmlinux1] Error 1


Searching the archives brought up old issues with gcc-3.4 [0] and not so 
old posting from 01/2008 [1], but I could not find a solution (or a 
consense about (not to) include libgcc.a).

Full make.log and .config: http://nerdbynature.de/bits/2.6.25.1/xen/

Hints welcome :)

Thanks,
Christian.

[0] http://gcc.gnu.org/ml/gcc/2004-01/msg01975.html
[1] http://www.nabble.com/gcc-4.3:-Kernel-build-fails-td15135607.html
-- 
BOFH excuse #328:

Fiber optics caused gas main leak
