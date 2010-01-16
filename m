Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0APIzc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 03:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909Ab0APIzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 03:55:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52455
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751898Ab0APIzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 03:55:31 -0500
Date: Sat, 16 Jan 2010 00:55:41 -0800 (PST)
Message-Id: <20100116.005541.18991049.davem@davemloft.net>
To: mingo@elte.hu
CC: linux-kernel@vger.kernel.org
Subject: sched_clock.c change to -stable?
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo, I need commit:

commit b9f8fcd55bbdb037e5332dbdb7b494f0b70861ac
Author: David Miller <davem@davemloft.net>
Date:   Sun Dec 13 18:25:02 2009 -0800

    sched: Fix cpu_clock() in NMIs, on !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
    
as a dependency on some sparc perf bug fixes I'd like to
submit to -stable.

Therefore, do you mind if I send this commit to -stable?

Thanks.
