Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbZJENBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbZJENBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 09:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbZJENBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 09:01:34 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:63274 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbZJENBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 09:01:33 -0400
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [.32-rc3] scheduler: iwlagn consistently high in "waiting for CPU"
Date: Mon, 5 Oct 2009 15:00:54 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910051500.55875.elendil@planet.nl>
X-OriginalArrivalTime: 05 Oct 2009 13:00:55.0976 (UTC) FILETIME=[E06A8A80:01CA45BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With .32-rc3 I'm getting occasional skips from amarok while playing music 
from an NFS share (3 today so far), something I've not had in a long time.

The reason looks to be that latencytop consistently shows 'iwlagn' as the 
top affected process with "Scheduler: waiting for CPU".
Values of 100-140 ms occur frequently, but I've also seen higher values 
(180, 207). I don't remember seeing iwlagn high in the list before, but I 
have not checked earlier kernels yet.

Added to that 'phy0' also frequently shows high with values of 25-75 ms.

The system is otherwise essentially idle. Other processes typically show a 
latency < 5 ms.

System: HP 2510p notebook, x86_64, Core2 Duo, Debian stable

Cheers,
FJP
