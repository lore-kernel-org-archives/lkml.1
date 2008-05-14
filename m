Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbYENEXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbYENEXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 00:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbYENEXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 00:23:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60099 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYENEXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 00:23:41 -0400
Date: Wed, 14 May 2008 13:22:52 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Subject: Re: [PATCH 0/9] Scalability requirements for sysv ipc - v3
Cc: kosaki.motohiro@jp.fujitsu.com, KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, akpm@linux-foundation.org
In-Reply-To: <4829A15A.1070203@bull.net>
References: <2f11576a0805070619x11c462fdpbee1b652a83d7071@mail.gmail.com> <4829A15A.1070203@bull.net>
Message-Id: <20080514132134.1A98.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, looks like the description was not clear, sorry for that!
> 1st column: 2.6.25-rc3-mm1 with original ipc implementation
>                             (i.e. ipcs stored in an array)
> 2nd column: 2.6.25-rc3-mm1, with ipcs stored in an idr tree
>              actually, that's when the performance regression
>              had been introduced.
> 3rd column: 2.6.25-mm1, still with the same implementation
>              i.e. still with degraded performances.
> 4th column: 2.6.25-mm1 + rcu-based implementation of the idr,
>              which is the current patch series.
> 
> Hope this makes things more clear.

Oh, I see that your patchset has very nice performance result :)
Thanks!


