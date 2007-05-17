Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbXEQPeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbXEQPeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 11:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbXEQPe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 11:34:28 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:42992 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbXEQPe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 11:34:27 -0400
Date: Thu, 17 May 2007 17:30:26 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Neil Brown <neilb@suse.de>
cc: Jeff Zheng <Jeff.Zheng@endace.com>, david@lang.hm,
       Andreas Dilger <adilger@clusterfs.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: RE: Software raid0 will crash the file-system, when each disk is
 5TB
In-Reply-To: <17996.14421.769180.782589@notabene.brown>
Message-ID: <Pine.LNX.4.61.0705171724500.3231@yvahk01.tjqt.qr>
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
 <20070516140452.GC5286@schatzie.adilger.int> <Pine.LNX.4.64.0705161058430.1280@asgard.lang.hm>
 <Pine.LNX.4.61.0705162016060.9019@yvahk01.tjqt.qr>
 <659F626D666070439A4A5965CD6EBF406B3324@gazelle.ad.endace.com>
 <Pine.LNX.4.61.0705170918480.1791@yvahk01.tjqt.qr> <17996.14421.769180.782589@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 17 2007 21:11, Neil Brown wrote:
>On Thursday May 17, jengelh@linux01.gwdg.de wrote:
>> XOR it (0^0=1), and hence fills up the host disk.
>
>Uhmm... you need to check your maths.
>
>$ perl -e 'printf "%d\n", 0^0;'
>0
>
>:-)

(ouch)
You know just as I that ^ is the power operator!
I just... wrongly named it XOR :p

$ echo '0^0' | bc -l
1


Well, right, setting up a blank raid5 array inside vmware will not make
the host file significantly larger, making it easy to build megatera
arrays with gigabyte range host disks.


	Jan
-- 
