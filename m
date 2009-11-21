Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbZKUTK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbZKUTK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 14:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZKUTK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 14:10:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45545
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071AbZKUTK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 14:10:28 -0500
Date: Sat, 21 Nov 2009 11:10:45 -0800 (PST)
Message-Id: <20091121.111045.170330916.davem@davemloft.net>
To: phdm@macqel.be
Cc: grundler@parisc-linux.org, kyle@mcmartin.ca, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: tulip : kernel BUG in tulip_up/tulip_resume
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091108223305.GA21072@frolo.macqel>
References: <20090127165727.GA25748@frolo.macqel>
	<20090129210701.GA8092@frolo.macqel>
	<20091108223305.GA21072@frolo.macqel>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe De Muyter <phdm@macqel.be>
Date: Sun, 8 Nov 2009 23:33:05 +0100

> I have just installed 2.6.31 (from opensuse 11.2) one a tulip-equipped
> computer and I get the following error message from the kernel :

I took some looks at this bug.

I simply can't figure out how this is possible.  As both suspend
and resume make sure to make the necessary napi_disable() and
napi_enable() calls, and therefore they should match up and not
trigger this BUG().

I'll try to study the code some more when I get a chance.
