Return-Path: <linux-kernel-owner+w=401wt.eu-S1161039AbXBUPI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161039AbXBUPI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161275AbXBUPIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:08:24 -0500
Received: from [212.12.190.63] ([212.12.190.63]:32862 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161250AbXBUPGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:06:52 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] free swap space when (re)activating page
Date: Wed, 21 Feb 2007 18:09:45 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702211809.45705.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Rik van Riel wrote:
> > ... because I think this is what my patch does :)
>
> Never mind, I see it now.
>
> The attached patch should be correct.

Your patch seems to improve the situation a little bit, but the numbers still 
look weird, especially for swap-in, which gets progressively slower.

RAM 512mb , SWAP 1G
#mount -t tmpfs -o size=1G none /dev/shm
#time cat /dev/full > /dev/shm/x.dmp
15sec
#time cat /dev/shm/x.dmp > /dev/null
58sec
#time cat /dev/shm/x.dmp > /dev/null
72sec
#time cat /dev/shm/x.dmp > /dev/null
85sec
#time cat /dev/shm/x.dmp > /dev/null
93sec
#time cat /dev/shm/x.dmp > /dev/null
99sec


Thanks!

--
Al

