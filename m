Return-Path: <linux-kernel-owner+w=401wt.eu-S2992913AbXDRRZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992913AbXDRRZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 13:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992909AbXDRRZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 13:25:21 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:53583 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992913AbXDRRZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 13:25:20 -0400
Date: Wed, 18 Apr 2007 13:25:19 -0400
To: Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>
Cc: Diego Calleja <diegocg@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Mike Snitzer <snitzer@gmail.com>, Neil Brown <neilb@suse.de>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Message-ID: <20070418172519.GA5577@csclub.uwaterloo.ca>
References: <17952.5537.364603.419364@notabene.brown> <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com> <Pine.LNX.4.61.0704142251380.15892@yvahk01.tjqt.qr> <Pine.BSO.4.63.0704161120070.11088@rudy.mif.pg.gda.pl> <46238204.9060907@s5r6.in-berlin.de> <Pine.BSO.4.63.0704161606280.11088@rudy.mif.pg.gda.pl> <20070416145527.GA26863@infradead.org> <Pine.BSO.4.63.0704161734370.11088@rudy.mif.pg.gda.pl> <20070416210254.d619933c.diegocg@gmail.com> <Pine.BSO.4.63.0704162110200.11088@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.BSO.4.63.0704162110200.11088@rudy.mif.pg.gda.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 10:18:45PM +0200, Tomasz K?oczko wrote:
> Of cources it can be true in most cases (probably for some more advanced 
> RAID controlers). Few weeks ago I perform some basic test on Dell 2950 
> with 8x73GB SAS disk .. just as for kill time (waiting for access to some 
> bigger box ;). This small iron box have inside RAID controller (Dell uses 
> in this box LSI Logic SAS MegaRAID based ctrl). Anykind combinations on 
> controler level RAID was slower than using this as plain JBOD with LVM or 
> MD+LVM. Diffrence between HW and soft RAID was not so big (1-6% depending 
> on configuration) but allways HW produces worser results (don't ask me 
> why). Finaly I decide using this disk as four RAID1 luns only because 
> under Linux I can't read each phisical disk SMART data and protecting this 
> by RAID on controller level and collecting SNMP traps from DRAC card was 
> kind of worakaround for this (in my case it will be better constanlty 
> monitor disk healt and collesting some SMART data for observe trends on 
> for example zabbix graphs for try predict some faults using triggers). On 
> top of this was configured diffrent types of volumes on LVM level (some 
> with stripping some without, some with bigger some with smaller chunk 
> size).

Does it matter that google's recent report on disk failures indicated
that SMART never predicted anything useful as far as they could tell?
Certainly none of my drive failures ever had SMART make any kind of
indication that anything was wrong.

I think the main benefit of MD raid, is that it is portable, doesn't
lock you into a specific piece of hardware, and you can span multiple
controllers, and it is likely easier to have bugs in MD raid fixed that
in some raid controller's firmware if any were to be found.  Performance
advantages are a bonus of course.

--
Len Sorensen
