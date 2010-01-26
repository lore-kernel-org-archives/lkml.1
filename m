Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710Ab0AZHR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab0AZHR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 02:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110Ab0AZHR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 02:17:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50400
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752056Ab0AZHRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 02:17:24 -0500
Date: Mon, 25 Jan 2010 23:17:35 -0800 (PST)
Message-Id: <20100125.231735.216761126.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100126063326.GA6360@ff.dom.local>
References: <20100125.165634.92235663.davem@davemloft.net>
	<20100126063326.GA6360@ff.dom.local>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Tue, 26 Jan 2010 06:33:26 +0000

> On 26-01-2010 01:56, David Miller wrote:
>> are available in the git repository at:
>> 
>>   master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master
> 
> David, I hope I miss something, but there seem to be older things too:
> ...
>> Jarek Poplawski (1):
>>       ax25: netrom: rose: Fix timer oopses

That was commited on January 16th.

commit d00c362f1b0ff54161e0a42b4554ac621a9ef92d
Author: Jarek Poplawski <jarkao2@gmail.com>
Date:   Sat Jan 16 01:04:04 2010 -0800

    ax25: netrom: rose: Fix timer oopses
    
    Wrong ax25_cb refcounting in ax25_send_frame() and by its callers can
    cause timer oopses (first reported with 2.6.29.6 kernel).
    
    Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=14905
    
    Reported-by: Bernard Pidoux <bpidoux@free.fr>
    Tested-by: Bernard Pidoux <bpidoux@free.fr>
    Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

And I haven't sent a pull request to Linus since around
January 13th
