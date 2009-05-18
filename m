Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbZERMEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbZERMEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 08:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbZERMEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 08:04:24 -0400
Received: from web26106.mail.ukl.yahoo.com ([217.146.182.147]:40534 "HELO
	web26106.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754515AbZERMEY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 08:04:24 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 May 2009 08:04:23 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pL4ifYn5l2n/qBpfbtVy5NHFHpUwuEkBSHCgw4ZAq7qa+GLJaIZaDYBID5557XpqC6ArN14mw8pE0p/Olg3CXTGp64aQKUVOPQRe0PYl0I9fvNvz5zPvM6JamsPTHmYxMyy+HyjDkDoAOePRg+cGeGg1A3dNhS8SToq9zAlom2w=;
Message-ID: <865071.76281.qm@web26106.mail.ukl.yahoo.com>
X-YMail-OSG: 7r9FWDgVM1kgt6wVAfQvT6f3.uh3E3uJtkGhb4b05AagKZ9EnYIKk92ST1IRQlOyvx_jFIj1OQCEJhh91hZdrb2Sbu7bUvFC8Y2ym4AWXXowsE7ja9i_yYTxKQQKwj1vp9D7Yn4s_2uOiCM8HBnKq6r63cq7BEMkOa7GtKn0v7oX8jUwEIbR6YQklqq65wt2.LFWzAX3V307dh1VxdtmlTAFEkpmS545hjmJV3RcA5DXan9qdGYK8MYd2NLfOoFwWf_WQVy1_0ntJ_Clh94q7bKWAub.K3cwt9Zfq_uFvQ18Fc3BdbAz8Gi0.fJkoJoXGUG5Mm0cv9W3S4EZhxn5v2dq
X-Mailer: YahooMailClassic/5.3.9 YahooMailWebService/0.7.289.10
Date: Mon, 18 May 2009 11:57:43 +0000 (GMT)
From: John Zupfel <jzupfel@yahoo.co.uk>
Subject: Houston, we have a problem: big file copying, USB, external disks
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Are recent kernels (since somewhere around 2.6.27 - 2.6.28)
choking on big file copying?


https://bugs.launchpad.net/ubuntu/+source/gvfs/+bug/197762?comments=all

Quoting the latest post:
> No, it's not Ubuntu specific and Canonical didn't cause it.
> 
> Right now I'm copying between two SATA drives, connected to my PC via
> eSATA.  So far a lousy 600MB has been copied and I'm already down to
> 5MB/s and falling.
> 
> Here is what I know about the problem:
> 
> It affects ALL hardware.
> 
> It affects ALL file copying connections to varying degrees: USB,
> network, SATA/eSATA.
> 
> In some instances, it also affects multitasking, all but locking the
> computer up despite little to no CPU use in System Monitor.
> 
> There are no error logs, messages or anything else that occur when the
> problem is happening.
> 
> In my experience, if you test for the problem and nothing seems to be
> wrong, then that's because you aren't copying enough data, you don't
> know how fast your hardware should be copying files, or you are lucky
> enough to only be subtly affected that time.  Try copying more multi-
> gigabytes of data, several times and see if you can't get wildly
> different durations for the same data size.  As I state above, all
> hardware I have tested is affected to varying degrees, some hardware
> shows minor performance degradation over time, some hardware is all but
> useless for file copying.
> 
> If you ask me, it's either the scheduler (GUI lockups with no CPU usage
> makes me think this) or whatever performs the actual file copy process.
> It's definitely not a USB problem because it affects network copying
> too.



      
