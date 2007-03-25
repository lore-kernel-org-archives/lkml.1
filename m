Return-Path: <linux-kernel-owner+w=401wt.eu-S965114AbXCYEpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114AbXCYEpN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 00:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933082AbXCYEpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 00:45:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59935
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932279AbXCYEpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 00:45:11 -0400
Date: Sat, 24 Mar 2007 21:45:09 -0700 (PDT)
Message-Id: <20070324.214509.98750566.davem@davemloft.net>
To: bunk@stusta.de
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jareguero@telefonica.net,
       oliver.pntr@gmail.com, g3vbv@blueyonder.co.uk
Subject: Re: [1/5] 2.6.21-rc4: known regressions (v2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070323184816.GO752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<20070323184816.GO752@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Fri, 23 Mar 2007 19:48:17 +0100

> Subject    : problem with sockets
> References : http://lkml.org/lkml/2007/3/21/248
> Submitter  : Jose Alberto Reguero <jareguero@telefonica.net>
> Status     : unknown

Not enough information in his report, for example for the
case he says does not work he fails to indicate what kernel
or system type the Client runs on.

Furthermore, his scripts don't even execute properly when
I try to run them myself, for example server.py gives me
this syntax error when python tries to parse the script:

davem@sunset:~/src/GIT/net-2.6$ /usr/bin/python server.py
  File "server.py", line 9
    struct sockaddr_in ServerAddr;
                     ^
SyntaxError: invalid syntax


Can someone help de-crapify this bug report?
