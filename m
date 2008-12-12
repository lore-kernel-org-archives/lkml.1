Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbYLLCKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbYLLCKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 21:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbYLLCKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 21:10:05 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:58961 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017AbYLLCKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 21:10:02 -0500
Message-Id: <200812120209.mBC29Qx5064845@www262.sakura.ne.jp>
Subject: [mmotm-2008-12-11-15-20] __unsafe() not defined.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Dec 2008 11:09:26 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this compilation error using gcc (GCC) 3.3.5 (Debian 1:3.3.5-13).

  drivers/pci/hotplug/ibmphp_core.c: In function `ibmphp_init':
  drivers/pci/hotplug/ibmphp_core.c:1409: error: implicit declaration of function `__unsafe'
  make[3]: *** [drivers/pci/hotplug/ibmphp_core.o] Error 1
  make[2]: *** [drivers/pci/hotplug] Error 2
  make[1]: *** [drivers/pci] Error 2
  make: *** [drivers] Error 2

"grep -Fr __unsafe ." shows only one line.

  ./drivers/pci/hotplug/ibmphp_core.c:    __unsafe(THIS_MODULE);

Where is __unsafe defined?

Regards.
