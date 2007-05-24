Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbXEXD20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbXEXD20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 23:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758632AbXEXD2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 23:28:18 -0400
Received: from ihemail4.lucent.com ([135.245.0.39]:39794 "EHLO
	ihemail4.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758629AbXEXD2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 23:28:18 -0400
Message-ID: <4655064F.1030808@alcatel-lucent.com>
Date: Thu, 24 May 2007 11:28:15 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: How to produce a core
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 May 2007 03:27:25.0953 (UTC) FILETIME=[731FF710:01C79DB3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This morning, I tried command "kill -7 [pid]" but didn't see the core 
file. Anybody has ideas?

bash-2.05b# ps
PID   USER     COMMAND
    1 0        init  
    2 0        [ksoftirqd/0]
    3 0        [watchdog/0]
    4 0        [events/0]
    5 0        [khelper]
    6 0        [kthread]
   36 0        [kblockd/0]
   38 0        [kseriod]
   50 0        [pdflush]
   51 0        [pdflush]
   52 0        [kswapd0]
   53 0        [aio/0]
  171 0        -sh 
  174 0        [rpciod/0]
  182 0        bash 
  198 0        gdi_trans 16777471 0 0 12 1 0 10000 8000 0 0 0 1 1 
  204 0        ps 
bash-2.05b# kill -7 198
bash-2.05b# ps
PID   USER     COMMAND
    1 0        init  
    2 0        [ksoftirqd/0]
    3 0        [watchdog/0]
    4 0        [events/0]
    5 0        [khelper]
    6 0        [kthread]
   36 0        [kblockd/0]
   38 0        [kseriod]
   50 0        [pdflush]
   51 0        [pdflush]
   52 0        [kswapd0]
   53 0        [aio/0]
  171 0        -sh 
  174 0        [rpciod/0]
  182 0        bash 
  205 0        ps 
[1]+  Bus error               gdi_trans 16777471 0 0 12 1 0 10000 8000 0 0 0 1 1


