Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbYKCFDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbYKCFDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 00:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbYKCFDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 00:03:07 -0500
Received: from kuber.nabble.com ([216.139.236.158]:57493 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbYKCFDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 00:03:06 -0500
Message-ID: <20297391.post@talk.nabble.com>
Date: Sun, 2 Nov 2008 21:03:04 -0800 (PST)
From: peter360 <peter360@fastmail.us>
To: linux-kernel@vger.kernel.org
Subject: which .ko file?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: peter360@fastmail.us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

How do I determine the .ko file used for a certain kernel module in a
running kernel?  For example, on my dell laptop I see
$ lsmod | grep 3945
ipw3945               230952  1 
ieee80211              65161  1 ipw3945

$ modinfo ipw3945
modinfo: could not open /lib/modules/2.6.18-92.1.1.el5/extra/ipw3945.ko: No
such file or directory

$ locate ipw3945.ko
/lib/modules/2.6.18-52.el5/weak-updates/ipw3945.ko
/lib/modules/2.6.18-52.el5/weak-updates/ipw3945/ipw3945.ko
/lib/modules/2.6.18-8.1.4.el5/extra/ipw3945/ipw3945.ko
/lib/modules/2.6.18-92.1.1.el5/weak-updates/ipw3945/ipw3945.ko
/lib/modules/2.6.18-92.1.10.el5/weak-updates/ipw3945.ko
/lib/modules/2.6.18-92.1.10.el5/weak-updates/ipw3945/ipw3945.ko

$ uname -a
Linux mylaptop 2.6.18-92.1.1.el5 #1 SMP Thu May 22 09:01:47 EDT 2008 x86_64
x86_64 x86_64 GNU/Linux

How do I find out which ipw3945.ko file was actually loaded into the kernel?
thanks!
-- 
View this message in context: http://www.nabble.com/which-.ko-file--tp20297391p20297391.html
Sent from the linux-kernel mailing list archive at Nabble.com.

