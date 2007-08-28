Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbXH1IXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbXH1IXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 04:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbXH1IXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 04:23:45 -0400
Received: from smtp.cdmon.com ([212.36.74.230]:65417 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbXH1IXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 04:23:44 -0400
X-Greylist: delayed 1878 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Aug 2007 04:23:44 EDT
Date: Tue, 28 Aug 2007 09:51:55 +0200
From: DervishD <lkml@dervishd.net>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: cpufreq affects traffic control rates
Message-ID: <20070828075155.GG17475@DervishD>
Mail-Followup-To: Linux-kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi all :)

    I noticed lately that my traffic control rates were being very slow,
about 40% less than expected, and finally spotted the problem: cpufreq.

    Looks like HTB puts buckets according to the requested rate but
assuming that the CPU is running at its default clock or something like
that.

    Any way of fixing this without disabling cpufreq?

    I'm using kernel 2.6.20.14, Athlon64 1000/1800MHz, HZ=1000 and a
combination of HTB/SFQ in my traffic control.

    Thanks a lot in advance :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
