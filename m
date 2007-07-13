Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbXGMS1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbXGMS1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760588AbXGMS1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:27:00 -0400
Received: from toro.web-alm.net ([62.245.132.31]:43323 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760633AbXGMS07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:26:59 -0400
X-Greylist: delayed 4018 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jul 2007 14:26:58 EDT
Message-ID: <4697B3E5.1050907@osadl.org>
Date: Fri, 13 Jul 2007 19:18:29 +0200
From: Carsten Emde <Carsten.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.8.1.4) Gecko/20070606 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: v2.6.22.1-rt3 - Early INT13 boot crash
References: <1184325752.12353.312.camel@chaos>
In-Reply-To: <1184325752.12353.312.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

> we are pleased to announce the v2.6.22.1-rt3 kernel
Thanks a lot!

Using the .config file from the previous stable version (2.6.21.6-rt21), 
the new version runs okay on an x86_64 system. On an i386 system, 
however, the system is crashing at an early boot stage displaying an 
INT13 reg dump at the window bottom.

After disabling paravirtualization support (CONFIG_PARAVIRT), the new 
version is working fine on i386 as well.

Just in case someone out there is experiencing the same problem.

	--cbe
