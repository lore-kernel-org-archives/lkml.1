Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbZBBUFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbZBBUFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbZBBUFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:05:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38643
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbZBBUFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:05:11 -0500
Date: Mon, 02 Feb 2009 12:05:07 -0800 (PST)
Message-Id: <20090202.120507.152093960.davem@davemloft.net>
To: andrew@walrond.org
Cc: jengelh@medozas.de, sam@ravnborg.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.28 headers break kbd and net-tools userspace builds
From: David Miller <davem@davemloft.net>
In-Reply-To: <4986CC6D.4090904@walrond.org>
References: <20090128.122924.106238702.davem@davemloft.net>
	<alpine.LSU.2.00.0901300510310.22910@fbirervta.pbzchgretzou.qr>
	<4986CC6D.4090904@walrond.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Walrond <andrew@walrond.org>
Date: Mon, 02 Feb 2009 10:35:25 +0000

> Hey guys. A gentle nudge...
> 
> My distro scripts build the
> 
>     glibc
>     iproute2
>     iputils
>     kbd
>     lm_sensors
>     net-tools
>     strace
> 
> packages and others against every new release of linux and linux-stable, (hence my initial report).
> Right now I'm stalled at the 2.6.27.? headers so can't do any more testing until this is resolved.

There isn't anything we can really do about these cases.

No matter what we do, we break the userland build in one way or
another.
