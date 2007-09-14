Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbXINWaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbXINWaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 18:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbXINWa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 18:30:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41682
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756493AbXINWa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 18:30:27 -0400
Date: Fri, 14 Sep 2007 15:30:25 -0700 (PDT)
Message-Id: <20070914.153025.41635808.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: lethal@linux-sh.org, mikey@neuling.org, jdi@l4x.org, paulus@samba.org,
       torvalds@linux-foundation.org, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, alan@redhat.com,
       heiko.carstens@de.ibm.com, hskinnemoen@atmel.com, dhowells@redhat.com
Subject: Re: Define termios_1 functions for powerpc, s390, avr32 and frv
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070914151253.d7943119.akpm@linux-foundation.org>
References: <20070913035506.b599e84f.akpm@linux-foundation.org>
	<20070914.113324.104043149.davem@davemloft.net>
	<20070914151253.d7943119.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 14 Sep 2007 15:12:53 -0700

> That fixes sparc, but I think other architectures are still broken.  And if
> we use Tony's ifdef patch to fix the other architectures, that makes the
> above sparc-fix patch unneeded.
> 
> argh.

I don't care if we use Tony's fix or mine, both are fine.

What I do care about is that I spent 24 hours on trains and
planes, only to find more than a day later that Sparc still
didn't build.
