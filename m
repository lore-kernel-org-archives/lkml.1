Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbZKFIib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbZKFIib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbZKFIia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:38:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39041
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754404AbZKFIia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:38:30 -0500
Date: Fri, 06 Nov 2009 00:38:55 -0800 (PST)
Message-Id: <20091106.003855.41136064.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, jkacur@redhat.com, tglx@linutronix.de,
       fweisbec@gmail.com
Subject: Re: [PATCH 0/5] net: push down BKL into proto ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <1257431850-20874-1-git-send-email-arnd@arndb.de>
References: <1257431850-20874-1-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Thu,  5 Nov 2009 15:37:25 +0100

> This pushes one more use of the BKL from common code into specific
> network protocols by killing off the proto ops wrappers.
> This should cause no visible changes on the code but saves a few
> kilobytes of object code in allyesconfig.
> 
> Arnd Bergmann (5):
>   net/appletalk: push down BKL into a atalk_dgram_ops
>   net/ipx: push down BKL into a ipx_dgram_ops
>   net/irda: push BKL into proto_ops
>   net/x25: push BKL usage into x25_proto
>   net: kill proto_ops wrapper

Nice patch set Arnd.

As long as this passes my build validation checks it will
get pushed out to net-next-2.6

Thanks!
