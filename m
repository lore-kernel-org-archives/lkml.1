Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbYLPLb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbYLPLb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYLPLbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:31:47 -0500
Received: from smtp02.uc3m.es ([163.117.176.132]:46816 "EHLO smtp02.uc3m.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbYLPLbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:31:46 -0500
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Message-Id: <200812161131.mBGBVfV17064@inv.it.uc3m.es>
Subject: time_is_after_jiffies misnomer
To: "linux kernel" <linux-kernel@vger.kernel.org>
Date: Tue, 16 Dec 2008 12:31:41 +0100 (MET)
X-Anonymously-To: 
Reply-To: ptb@inv.it.uc3m.es
X-message-flag: Had your Outlook virus, today?  
	http://www.counterpane.com/crypto-gram-0103.html#4
X-WebTV-Stationery: Standard\; BGColor=black\; TextColor=black
Reply-By: Sat, 1 Apr 2006 14:21:08 -0700
X-Mailer: ELM [version 2.4ME+ PL66 (25)]
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-1.1500 TC:1F TRN:6 TV:5.5.1026(16342.006)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I thought at first that

    time_is_after_jiffies(foo)

meant that the current time is later than foo jiffies. In fact, it's
the reverse! (as far as I can tell! 2.6.26-11). 

Can we change this name or provide an alternative? Perhaps

   jiffies_is_later_than(foo)

??

Peter Breuer
