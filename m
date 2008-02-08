Return-Path: <linux-kernel-owner+w=401wt.eu-S934690AbYBHSgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934690AbYBHSgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760119AbYBHSgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:36:16 -0500
Received: from saturn.eclipse1.net ([208.75.87.223]:37073 "EHLO
	saturn.eclipse1.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYBHSgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:36:15 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2008 13:36:15 EST
DomainKey-Signature: a=rsa-sha1; s=saturn; d=eclipse1.net; c=nofws; q=dns;
	h=dkim-signature:received:message-id:date:subject:from:to:
	reply-to:user-agent:mime-version:content-type:
	content-transfer-encoding:x-priority:importance;
	b=SddA3vvVdRFjPclN1hm52llVI0xbIgf4aPSBssoRx3vuwarU8dBbI0ROvVlGhu5e9
	PWKN3dGr4SOb8ELRJhvuxztxGsd+E/ltcu/8KkfHNz8vdXLscvn8zq0m7GUKpotR6Qk
	bSWKkdNy9GRr0MH3WAlZ1iGdq23xZ7Otp0PCvB0=
Message-ID: <51961.193.35.133.151.1202495388.squirrel@www.eclipse1.net>
Date: Fri, 8 Feb 2008 18:29:48 -0000 (UTC)
Subject: CGroup subsystem for enforcing hard cpu rate limits
From: "Chris Brox" <lkml@orange.eclipse1.net>
To: linux-kernel@vger.kernel.org
Reply-To: "Chris Brox" <lkml@orange.eclipse1.net>
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back in 2006 Srivatsa Vaddagiri summarised proposals for CPU controllers,
which variously offered to limit or guarantee CPU for a task group. Some
of these supported both soft and hard limits.

Now in 2008 we have FAIR_CGROUP_SCHED in mainline, which supports soft CPU
limits per control group. Great stuff.

Unfortunately I am keenly looking for a hard CPU limit implementation -
i.e. one that would constrain a control group to use no more than x% of
the CPU, even when it is otherwise idle.

Has the hard limit idea been discarded, or is it still a planned feature
(of either the Fair scheduler or a new subsystem)?


