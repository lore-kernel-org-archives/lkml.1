Return-Path: <linux-kernel-owner+w=401wt.eu-S934287AbYETSPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287AbYETSPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933205AbYETSJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:09:38 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:4350 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933431AbYETSJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:09:37 -0400
Message-ID: <483313DD.2020904@hp.com>
Date: Tue, 20 May 2008 14:09:33 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: /proc/lock_stat "stuck"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm attempting to use /proc/lock_stat to gather some information during
some benchmarking runs, but what I find happens is as follows:

1. I boot the system - 2.6.26-rc3 kernel + CONFIG_LOCK_STAT=y

2. I can then look at /proc/lock_stat, and it has valid-looking values

3. I wait a while, do some stuff, but when I look at /proc/lock_stat
again the values have not changed.

4. If I clear the counters - echo 0 > /proc/lock_stat - the counters
never increase, and no information besides the headers are output when I
cat /proc/lock_stat.


Is there something that one needs to do to get counter updates?

Thanks,
Alan D. Brunelle
