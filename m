Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbZGZXXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbZGZXXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZGZXUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:20:03 -0400
Received: from joust.gpcc.itd.umich.edu ([141.211.2.207]:59126 "EHLO
	joust.gpcc.itd.umich.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbZGZXUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:20:00 -0400
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jul 2009 19:20:00 EDT
From: "Matthew D. Reuther" <mreuther@joust.gpcc.itd.umich.edu>
Date: Sun, 26 Jul 2009 19:10:25 -0400
To: linux-kernel@vger.kernel.org
Subject: android lowmemorykiller breaks compile
Message-ID: <4A6CE261.mailHX41REN0Z@joust.gpcc.itd.umich.edu>
User-Agent: nail 10.5 4/27/03
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't actually use Android, but I compile it just for giggles. With every one of the 2.6.31-rc releases, my compile breaks when it hits lowmemorykiller:

drivers/staging/android/lowmemorykiller.c: In function 'lowmem_shrink':
drivers/staging/android/lowmemorykiller.c:106: error: 'struct task_struct' has no member named 'oomkilladj'
make[3]: *** [drivers/staging/android/lowmemorykiller.o] Error 1
make[2]: *** [drivers/staging/android] Error 2

Maybe this should not be selectable for x86? Can't tell.

config:
