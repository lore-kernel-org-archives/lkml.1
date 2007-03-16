Return-Path: <linux-kernel-owner+w=401wt.eu-S965971AbXCPVwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965971AbXCPVwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965974AbXCPVwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:52:07 -0400
Received: from [212.12.190.214] ([212.12.190.214]:32924 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965971AbXCPVwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:52:05 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: decrease L2 cache size used by Linux?
Date: Sat, 17 Mar 2007 00:55:27 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703170055.27126.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guerreiro da Luz wrote:
> Am benchmarking dumb matrix multiplication in trying to perceive
> performance drop in case when matrix cannot fit in L2 cache.  However,
> on my machine L2 cache is large - 2MB, so 512x512 matrix of double
> numbers is needed to fill the cache, and in that case multiplication
> is taking rather long time.  So I'm wondering is there a way to
> control (decrease) L2 cache size used by Linux?  Apologies if question
> inappropriate for the list.

You may want to turn off randomization,
 
echo 0 > /proc/sys/kernel/randomize_va_space
echo 1 > /proc/sys/vm/vdso_enabled

And see if that helps.


Thanks!

--
Al

