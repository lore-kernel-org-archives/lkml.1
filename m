Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbYFJVHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbYFJVHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758197AbYFJVGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:06:55 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:64592 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757670AbYFJVGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:06:54 -0400
Message-ID: <484EED06.8060301@lwfinger.net>
Date: Tue, 10 Jun 2008 16:07:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Kevin Winchester <kjwinchester@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Warning when compiling arch/x86/mm/init_64.c on x86_64
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 511631011d39706ac81ee5e4c9084d61e5b4fd34, entitled
"x86: fix pointer type warning in arch/x86/mm/init_64.c:early_memtest", the 
following warning is produced for x86_64:

arch/x86/mm/init_64.c: In function ‘early_memtest’:
arch/x86/mm/init_64.c:520: warning: passing argument 2 of 
‘find_e820_area_size’ from incompatible pointer type

Before this commit, the compilation of this routine on my system was clean. I 
use gcc version 4.2.1. Was this the warning for i386 before the patch? I 
tried simple changes in the definition of find_e820_area_size, but only 
managed to push the warning on to the call to bad_addr_size. At that point I 
decided to let the experts find a proper fix. Note that the warning does no 
harm - I just get nervous about incompatible pointer warnings as it usually 
means that I have screwed something up.

Larry

