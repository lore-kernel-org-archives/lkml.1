Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388Ab0A3RpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0A3RpL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 12:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996Ab0A3RpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 12:45:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51596 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751808Ab0A3RpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 12:45:08 -0500
Date: Sat, 30 Jan 2010 17:45:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: vedran.furac@gmail.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
Message-ID: <20100130174516.2257d7fa@lxorguk.ukuu.org.uk>
In-Reply-To: <4B646CBE.6050404@gmail.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126151202.75bd9347.akpm@linux-foundation.org>
	<20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126161952.ee267d1c.akpm@linux-foundation.org>
	<20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100128001636.2026a6bc@lxorguk.ukuu.org.uk>
	<4B622AEE.3080906@gmail.com>
	<20100129003547.521a1da9@lxorguk.ukuu.org.uk>
	<4B62327F.3010208@gmail.com>
	<20100129110321.564cb866@lxorguk.ukuu.org.uk>
	<4B64272D.8020509@gmail.com>
	<20100130125917.600beb51@lxorguk.ukuu.org.uk>
	<4B646CBE.6050404@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I can't say I'm able to correctly read kernel code, but I believe
> default is set by:

It['s set by the distribution - the kerne has a default value but given
the same distributions are shipping the crap userspace that breaks with
no-overcommit do you think they'll set it to break their user apps ?

No.

> http://vedranf.net/tmp/oom.ogv  (you can watch it using VLC for example)
> 
> Actually anyone receiving this mail should see it. What do you think,
> what will customers rather choose if they see this?

Address that to the distributions. Their customers. Systems I set up for
people always have no overcommit enabled.

Alan
