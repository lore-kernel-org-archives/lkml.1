Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbYDHIGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbYDHIGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYDHIFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:05:51 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:51834 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbYDHIFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:05:50 -0400
Date: Tue, 8 Apr 2008 11:05:47 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: file offset corruption on 32-bit machines?
Message-ID: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Robertson analyzes the behaviour of different operating systems' 
64-bit file offset implementation and concludes that on 32-bit 
machines, Linux and Solaris lack any locking to keep the two 32-bit 
halves in sync and this could cause rare file offset corruption.

http://jeffr-tech.livejournal.com/21014.html

-- 
Meelis Roos (mroos@linux.ee)
