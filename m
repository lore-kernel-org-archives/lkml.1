Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbXLYEhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbXLYEhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 23:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXLYEhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 23:37:08 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:32798 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbXLYEhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 23:37:06 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: linux-kernel@vger.kernel.org
Subject: nmi_watchdog killing tickless feature
Date: Tue, 25 Dec 2007 06:36:54 +0200
Message-Id: <20071225043654.M32161@visp.net.lb>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Please CC me on reply, i am not subscribed to list.

I did small test, and notice that if nmi_watchdog is enabled
mpstat 1

06:11:00     CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal  
%idle    intr/s
06:11:01     all    0.00    0.00    0.00    0.00    0.00    0.00    0.00 
100.00    993.07
06:11:02     all    0.00    0.00    0.00    0.00    0.00    0.00    0.00 
100.00   1007.00
06:11:03     all    0.00    0.00    0.00    0.00    0.00    0.00    0.00 
100.00   1005.00

if disabled
06:13:52     CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal  
%idle    intr/s
06:13:53     all    0.00    0.00    0.00    0.00    0.00    0.00    0.00 
100.00      1.00
06:13:54     all    0.00    0.00    0.00    0.00    0.00    0.00    0.00 
100.00      9.00
06:13:55     all    0.00    0.00    0.00    0.00    0.00    0.00    0.00 
100.00      4.00
06:13:56     all    0.00    0.00    0.00    0.00    0.00    0.00    0.00 
100.00      2.00
06:13:57     all    0.00    0.00    0.00    0.00    0.00    0.00    0.00 
100.00      2.00

The difference is huge, probably in power consumption too. Kernel is
relatively standard (2.6.24-rc6-git1), if required i can attach .config
If it is not bug, probably good to document, that it is killing powersaving
features?

--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

