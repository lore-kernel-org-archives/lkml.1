Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbZERMI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbZERMI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 08:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbZERMIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 08:08:16 -0400
Received: from mail-ausfall.charite.de ([193.175.70.131]:60409 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbZERMIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 08:08:15 -0400
Date: Mon, 18 May 2009 14:08:14 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Houston, we have a problem: big file copying, USB, external
	disks
Message-ID: <20090518120814.GK28462@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <865071.76281.qm@web26106.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <865071.76281.qm@web26106.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* John Zupfel <jzupfel@yahoo.co.uk>:
> 
> Are recent kernels (since somewhere around 2.6.27 - 2.6.28)
> choking on big file copying?
> 
> 
> https://bugs.launchpad.net/ubuntu/+source/gvfs/+bug/197762?comments=all

Does this happen AFTER a suspend/hibernate or ALL THE TIME?

> > No, it's not Ubuntu specific and Canonical didn't cause it.
> > 
> > Right now I'm copying between two SATA drives, connected to my PC via
> > eSATA.  So far a lousy 600MB has been copied and I'm already down to
> > 5MB/s and falling.
> > 
> > Here is what I know about the problem:
> > 
> > It affects ALL hardware.
> > 
> > It affects ALL file copying connections to varying degrees: USB,
> > network, SATA/eSATA.
> > 
> > In some instances, it also affects multitasking, all but locking the
> > computer up despite little to no CPU use in System Monitor.
> > 
> > There are no error logs, messages or anything else that occur when the
> > problem is happening.
> > 
> > In my experience, if you test for the problem and nothing seems to be
> > wrong, then that's because you aren't copying enough data, you don't
> > know how fast your hardware should be copying files, or you are lucky
> > enough to only be subtly affected that time.  Try copying more multi-
> > gigabytes of data, several times and see if you can't get wildly
> > different durations for the same data size.  As I state above, all
> > hardware I have tested is affected to varying degrees, some hardware
> > shows minor performance degradation over time, some hardware is all but
> > useless for file copying.
> > 
> > If you ask me, it's either the scheduler (GUI lockups with no CPU usage
> > makes me think this) or whatever performs the actual file copy process.
> > It's definitely not a USB problem because it affects network copying
> > too.
> 
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ralf Hildebrandt
  Geschäftsbereich IT | Abteilung Netzwerk
  Charité - Universitätsmedizin Berlin
  Campus Benjamin Franklin
  Hindenburgdamm 30 | D-12200 Berlin
  Tel. +49 30 450 570 155 | Fax: +49 30 450 570 962
  Ralf.Hildebrandt@charite.de | http://www.charite.de
