Return-Path: <linux-kernel-owner+w=401wt.eu-S1762939AbYDVKtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762939AbYDVKtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 06:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755755AbYDVKte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 06:49:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47997
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754709AbYDVKtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 06:49:33 -0400
Date: Tue, 22 Apr 2008 03:49:35 -0700 (PDT)
Message-Id: <20080422.034935.134139117.davem@davemloft.net>
To: kjwinchester@gmail.com
Cc: mingo@elte.hu, elendil@planet.nl, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, richie@coderworld.net,
       rjw@sisk.pl
Subject: Re: [git pull] scheduler changes for v2.6.26
From: David Miller <davem@davemloft.net>
In-Reply-To: <480DB2DB.9040908@gmail.com>
References: <200804211831.29976.elendil@planet.nl>
	<20080421194359.GD8770@elte.hu>
	<480DB2DB.9040908@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Winchester <kjwinchester@gmail.com>
Date: Tue, 22 Apr 2008 06:41:47 -0300

> kevin@alekhine:~/linux$ ./watch-rq-clock.sh
> 89.986517
> 81.033471
> 76.942776
> 90.986318
> 75.988551
> 85.987089
> 74.988696
> 85.987078
> 73.988858
> 88.986641
> 68.989600

The results on my 128-cpu Niagara2 box are even more interesting:

davem@maramba:~$ /bin/bash ./watch-rq-clock.sh 
0
0
0
0
0
0
0
0
0
0
0
0
0
...

I guess this script doesn't work correctly when the cpu
whose clock value it greps out of /proc/sched_debug is
in NOHZ mode?
