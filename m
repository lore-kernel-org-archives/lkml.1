Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbXDKSk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbXDKSk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbXDKSk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:40:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:42493 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752352AbXDKSk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:40:26 -0400
X-Authenticated: #36390367
X-Provags-ID: V01U2FsdGVkX1/f8kBUV5rf7iIdB4kSKAzgIm4G6L+ZWe9NNE5qYl
	KYtBz6KXP9sh7I
From: Markus =?iso-8859-15?q?Ko=DFmann?= <mkossmann_ml1@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: parallel port problems with 2.6.21_rc5 and 2.6.21_rc6_git3-20070410174235
Date: Wed, 11 Apr 2007 20:40:23 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704112040.23505.mkossmann_ml1@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When using either the unpatched  2.6.21_rc5   or SUSEs patched 
2.6.21_rc6_git3-20070410174235 on a SUSE-10.2 x86_64 system the parallel port 
doesn't work right. If I "cat some_asciifile >/dev/lp0"  the output on my 
Epson Stylus Color 880 is unreadable.  "cat /dev/zero >/dev/lp0"  creates 
random characters on the paper. Printing using cups also doesn't work any 
more. 
Switching back to SUSEs  2.6.18.8-0.1 kernel fixes the problem.
Any Ideas, what might be broken here ? 
