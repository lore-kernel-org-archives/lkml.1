Return-Path: <linux-kernel-owner+w=401wt.eu-S1751921AbXE2V3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbXE2V3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbXE2V3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:29:24 -0400
Received: from smtp5-g19.free.fr ([212.27.42.35]:43968 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbXE2V3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:29:23 -0400
Date: Tue, 29 May 2007 23:29:20 +0200
From: Jeremie Le Hen <jeremie@le-hen.org>
To: linux-kernel@vger.kernel.org
Cc: jeremie@le-hen.org
Subject: Puzzling lag in some syscalls
Message-ID: <20070529212920.GD31507@obiwan.tataz.chchile.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please Cc: me when replying, since I'm not subscribed.


I dare to ask this here because I have a problem that seems to be
either kernel or hardware related.  Unfortunately I can't see any
error message to direct me for further investigation.

I'm using 2.6.18-4-686 (Debian's kernel), but I've tried with 2.6.16.49
and 2.6.20.7 without success.

The problem is a big lag (more that 10 or 20 seconds) for some system
calls, for numerous unrelated applications (top, vim, apt-cache).
What is even more puzzling is that once the application has successfully
started, I can run it again without any lag.


I've used strace to catch a few lags.  "strace -fttT" has been used.
Note that you can view the content of these files directly in your
browser:

msync(0xb708f000, 8536, MS_SYNC), line 146/1035
http://tataz.chchile.org/~tataz/strace/strace.apt-cache.gz

select(0, NULL, NULL, NULL, {0, 500000}), line 575/1793
http://tataz.chchile.org/~tataz/strace/strace.top.gz

read(3, "diff --git a/.gitignore b/.gitig"..., 8192), line 797/2443
http://tataz.chchile.org/~tataz/strace/strace.vim.gz


Thank in advance.
Best regards,
-- 
Jeremie Le Hen
< jeremie at le-hen dot org >< ttz at chchile dot org >
