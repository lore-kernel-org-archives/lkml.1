Return-Path: <linux-kernel-owner+w=401wt.eu-S1161227AbXBUNgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161227AbXBUNgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 08:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161230AbXBUNgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 08:36:46 -0500
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:40873 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161227AbXBUNgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 08:36:45 -0500
Message-ID: <45DC4AE8.7050704@s5r6.in-berlin.de>
Date: Wed, 21 Feb 2007 14:36:40 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.8) Gecko/20061030 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Adrian Bunk <bunk@stusta.de>,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@muc.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Moore <dcm@mit.edu>
Subject: Re: [patch 00/21] 2.6.19-stable review
References: <20070221013619.GA30227@kroah.com>
In-Reply-To: <20070221013619.GA30227@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.19.5 release.
> 
> This will probably be the last release of the 2.6.19-stable series, so
> if there are patches that you feel should be applied to that tree,
> please let me know.

There is one here: "Missing critical phys_to_virt in lib/swiotlb.c".
http://lkml.org/lkml/2007/2/4/116
It fixes a DMA related bug which was seen with a variety of drivers
especially on EM64T machines with more than 3GB RAM. I hope you can
extract the patch from this MIME attachment.

Adrian, AFAICS it applies as-is to 2.6.16.y too. I don't have a machine
to test personally, but it is quite obvious.

The mentioned bigger patch has been merged by Linus between 2.6.20 and
2.6.21-rc1.
-- 
Stefan Richter
-=====-=-=== --=- =-=-=
http://arcgraph.de/sr/
