Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYGUUQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYGUUQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYGUUQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:16:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40136
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751554AbYGUUQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:16:00 -0400
Date: Mon, 21 Jul 2008 13:15:59 -0700 (PDT)
Message-Id: <20080721.131559.258601277.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: Larry.Finger@lwfinger.net, mingo@elte.hu, ischram@telenet.be,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0807211246280.31863@woody.linux-foundation.org>
References: <20080721193425.GA29287@elte.hu>
	<4884E6E6.7010800@lwfinger.net>
	<alpine.LFD.1.10.0807211246280.31863@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Jul 2008 12:47:58 -0700 (PDT)

> On Mon, 21 Jul 2008, Larry Finger wrote:
> > With an invalid opcode, mine is likely due to stack corruption.
> 
> No, invalid opcode is because we use the "ud2" instruction for BUG(), 
> which causes an invalid op exception. So any BUG[_ON]() will always cause 
> that on x86.

Is there really no more backtrace from that crash message?
It would tell me what driver it's in.

There is some "comm: b43" in the log so I'll check that one.
