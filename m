Return-Path: <linux-kernel-owner+w=401wt.eu-S932464AbXGWLfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbXGWLfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 07:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760924AbXGWLfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 07:35:10 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:38638 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759278AbXGWLfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 07:35:08 -0400
Message-ID: <46A49244.9010402@s5r6.in-berlin.de>
Date: Mon, 23 Jul 2007 13:34:28 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Manuel Lauss <mano@roarinelk.homelinux.net>
CC: Andreas Messer <andreas.messer@stud-mail.uni-wuerzburg.de>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [BUG] firewire: mass-storage i/o-problems
References: <200707222332.12270.andreas.messer@stud-mail.uni-wuerzburg.de> <46A3E973.6090701@s5r6.in-berlin.de> <20070723063741.GA32240@roarinelk.homelinux.net> <46A45B65.9000704@s5r6.in-berlin.de> <20070723084505.GB349@roarinelk.homelinux.net>
In-Reply-To: <20070723084505.GB349@roarinelk.homelinux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Lauss wrote:
> I noticed the failures start when there are 2 concurrent disk accesses
> (copy something from fw disk on shell 1 and it runs fine; start to
> copy something TO the fw disk on shell 2 and a "management write failed"
> error appears after 1-2 sec. with the orb timeout after a looong time)

Most of my tests have been with a single process, but I already tested
several processes at once in parallel too.  But probably only on the
bigger machine where neither the CPU nor the PCI bus (and this might be
important) would become a bottleneck.  I have to test this again on the
smaller machines.
-- 
Stefan Richter
-=====-=-=== -=== =-===
http://arcgraph.de/sr/
