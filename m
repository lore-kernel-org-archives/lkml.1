Return-Path: <linux-kernel-owner+w=401wt.eu-S1764573AbZE1UpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764573AbZE1UpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZE1UpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:45:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:52430 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760788AbZE1UpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:45:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=eAuVb+asjIQT0APETZ84ejzD8Ee4tg01O+u2FmUoR5nNEsG7Sai0r3snWC5qV6Ky+m
         DShCxHASmM7yvBLOSj3IH5ry28KyZ5ef7VSMhoi9jXqihd/PmtsuAflddXTC2gJh06c9
         vtI/s7WAI95iG3C8OJBfad+Arb0t5tgb2Fry0=
From: Diego Calleja <diegocg@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Performance regressions in 2.6.30-rc7?
Date: Thu, 28 May 2009 22:49:28 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-00187-gb4348f3; KDE/4.2.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905282249.28592.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, phoronix.com has run some benchmarks in 2.6.30-rc7 [1], there're some
good numbers, but there's also a couple of regressions. Some people think
that phoronix benchmarks are not very serious/reliable/meaningful, but i
thought it'd be better to post false warnings than letting real regressions
slip in without notice.

The regressions would be:
- 7zip MIPS ("7zr b" command) http://www.phoronix.com/data/img/results/linux_2630/1.png

- tiobench latency (not throughput) using 64MB writes with 32 threads
http://www.phoronix.com/data/img/results/linux_2630/7.png

-gnupg 2GB file encryption http://www.phoronix.com/data/img/results/linux_2630/3.png


Full article: http://www.phoronix.com/scan.php?page=article&item=linux_2630
