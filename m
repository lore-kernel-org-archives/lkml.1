Return-Path: <linux-kernel-owner+w=401wt.eu-S1765615AbXIMXng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765615AbXIMXng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbXIMXnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:43:19 -0400
Received: from james.oetiker.ch ([213.144.138.195]:54107 "EHLO
	james.oetiker.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbXIMXnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:43:18 -0400
X-Greylist: delayed 1773 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Sep 2007 19:43:18 EDT
Date: Fri, 14 Sep 2007 01:13:41 +0200 (CEST)
From: Tobias Oetiker <tobi@oetiker.ch>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] per device dirty throttling -v10
Message-ID: <alpine.DEB.0.999.0709140113210.8141@nyyzraq.brgvxre.pu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

I have been using your -v9 backport to 2.6.22 (thanks very much
btw) for the last few days on an amd64 system configured like this:

 [/],[/home],[/backup],...
  on top of
 [lvm2]
  using
 [/dev/sdb]
  which is an
 [areca hw raid 6 device made up from 8 sata disks]

With your patch, performance was much improved. But still there are
some seemingly simple tasks which do not work well. Like

 cp /home/bigfile.txt /backup/bigfile.txt

or also

 rm -r /backup/big-directory

They both affect disk access times of other processes very badly.

As I said, things improved a quite a bit with your patch, but I wonder
if there is more that could be done for this particular setup?

A second thing. Since my box has 8GB memory, I am intrigued by the
idea of setting dirty_ratio not as a ratio but as an absolute
number of kilobytes as it was suggested by Neil Brown with the
dirty_kb patch a few months back. Would it make sense to forward
port this patch on top of yours ?

cheers
tobi


-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten
http://it.oetiker.ch tobi@oetiker.ch ++41 62 213 9902

