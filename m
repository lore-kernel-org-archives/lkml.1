Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbZFCPXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbZFCPXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZFCPXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:23:14 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:35031 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbZFCPXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:23:13 -0400
Message-Id: <20090603152223.083010123@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Jun 2009 17:22:23 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [patch 0/2] NOHZ vs. profile/oprofile v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
version 2 of the profile patches. The only change is the in_interrupt()
fix in tick_nohz_stop_idle(). I would like to know how to proceed with
the issue.
Andy, do you still prefer to handle the old style profiler analog to
the oprofile patch? If yes I would drop patch #1 and extend patch #2
with another tick_nohz_disable().

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

