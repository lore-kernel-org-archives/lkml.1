Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab0APCGS (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 21:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758717Ab0APCGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 21:06:17 -0500
Received: from snt0-omc2-s24.snt0.hotmail.com ([65.55.90.99]:33479 "EHLO
	snt0-omc2-s24.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758696Ab0APCGR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 21:06:17 -0500
Message-ID: <SNT125-W39A63687E4BE4F52FAA517C3680@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: RE: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
Date: Fri, 15 Jan 2010 18:06:13 -0800
Importance: Normal
In-Reply-To: <4B511B12.6010208@zytor.com>
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>,<4B511B12.6010208@zytor.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Jan 2010 02:06:13.0659 (UTC) FILETIME=[7AE0E6B0:01CA9650]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The big difference isn't between HIGHMEM4G (no PAE) and HIGHMEM64G
> (PAE), it's between HIGHMEM and !HIGHMEM. That cutoff is ~892 MB for a
> stock 32-bit kernel.
Unfortunately most desktop/laptop systems nowadays ship with more than 1GB.Luckily, in the case of Atom netbooks that Linus mentioned, most Atom netbooks ship with only 1GB of RAM, partly due to MS's restrictions.However, disabling HIGHMEM will turn off NX which all Atom CPUs have, unless you turn CONFIG_PAE back on.
Yuhong Bao 		 	   		  
_________________________________________________________________
Hotmail: Trusted email with Microsoft’s powerful SPAM protection.
http://clk.atdmt.com/GBL/go/196390706/direct/01/