Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbZIBXp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbZIBXp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 19:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbZIBXp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 19:45:59 -0400
Received: from defender.gpcc.itd.umich.edu ([141.211.2.206]:50746 "EHLO
	defender.gpcc.itd.umich.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753817AbZIBXp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 19:45:58 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Sep 2009 19:45:58 EDT
From: "Matthew D. Reuther" <mreuther@defender.gpcc.itd.umich.edu>
Date: Wed, 02 Sep 2009 19:37:16 -0400
To: linux-kernel@vger.kernel.org
Subject: android lowmemorykiller breaks compile
Message-ID: <4A9F01AC.mailJ4G11FTGY@defender.gpcc.itd.umich.edu>
User-Agent: nail 10.5 4/27/03
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had some problems with this back in July, and then it was fixed in 2.6.31-rc5, and no it's broken again in 2.6.31-rc8.

drivers/staging/android/lowmemorykiller.c: In function 'lowmem_shrink':
drivers/staging/android/lowmemorykiller.c:108: error: 'struct mm_struct' has no
member named 'oom_adj'
make[3]: *** [drivers/staging/android/lowmemorykiller.o] Error 1
make[2]: *** [drivers/staging/android] Error 2
make[2]: *** Waiting for unfinished jobs....

I don't actually use the android drivers for anything. I compile them just fo my amusement.

Matt
