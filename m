Return-Path: <linux-kernel-owner+w=401wt.eu-S935383AbZLQO34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935383AbZLQO34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 09:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764807AbZLQO3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 09:29:50 -0500
Received: from trulit.net ([78.46.66.163]:42410 "EHLO mail.elenhost.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764814AbZLQO3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 09:29:49 -0500
X-Greylist: delayed 641 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Dec 2009 09:29:49 EST
MIME-Version: 1.0
Date: Thu, 17 Dec 2009 15:22:08 +0100
From: Ivan Gualandri <finarfin@dreamos.org>
To: linux-kernel@vger.kernel.org
Subject: Real Time scheduler infos
Message-ID: <117cfc288d1eed419c5f296d43167116@localhost>
User-Agent: RoundCube Webmail/0.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

i have a question about priorities in RT patchset. 

In linux priorites are from 1 to 139 (1 highest - 139 lowest)
And RT prorities are between 1 to 99. An i think 1 is highest and 139
lowest.

But now if i try to launch three tasks with 3 different priorities: 
for example 
A has priority 10
B has priority 20
C has priority 30 
I notice that the tasks B and C are always the first two to run. And A
always wait the end of B or C (also if A is the first task launched).

Now my question is: 
when i set priority of a RT task (changing the sched_priority field of my
task) the highest priority is 99 or 1? 

Thanks,
--i

P.s. Sorry for my bad english! 





