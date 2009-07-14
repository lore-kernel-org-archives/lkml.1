Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbZGNX2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbZGNX2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 19:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbZGNX2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 19:28:15 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:40456 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290AbZGNX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 19:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=cO0IxwxEkpeAC9n5zrUI7CAC5d/QjZM2cre0NupR0jwo+xxUidRAJaQxwRn3T5fQN7
         eXiHdXNV9fKD7p/OJTAv+OSFbzdtu1LW3MTCG24KnlqHqNBtgeUfENg8Xi+MpWF+aNOj
         MGjeqBtSkOgBr7jG3o4co9tAO5OVfjwfxa+Yc=
Message-ID: <4A5D148A.5090405@gmail.com>
Date: Tue, 14 Jul 2009 20:28:10 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090626)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: kmemleak reports
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Catalin,

I have noticed a few kmemleak reports being sent to LKML in the last few days, and I could chime in with mine, if you wish:

    kmemleak: 97 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

The entries are for X, ntpdate, scsi_scan_2, softirq, swapper, in case there's anything surprising in there.

However, I was thinking that you might soon start getting too many reports to process.  I wonder if there might be some way that you could have a similar facility to kerneloops that would automatically register leak reports to a website where they could be organized and ranked by number of occurrences.  Are the individual leaks reported in such at way that would allow them to be grouped like that?

If a kerneloops-style setup is not desirable/feasible, would you be able to send me a walkthrough for how you go about tracking down one of these leaks?  Then I might be able to help out by investigating a few of my own.

Thanks,

-- 
Kevin Winchester



