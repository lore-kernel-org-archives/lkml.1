Return-Path: <linux-kernel-owner+w=401wt.eu-S1758331AbXELS6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbXELS6z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbXELS6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:58:48 -0400
Received: from mail.suse.de ([195.135.220.2]:45103 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756705AbXELS6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:58:47 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH 2/2] i386: sched_clock() follows percpu frequency changes
Date: Sat, 12 May 2007 20:58:35 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnstul@us.ibm.com, mingo@elte.hu, Jiri Bohac <jbohac@suse.cz>
References: <20070512154344.395866578@mvista.com> <20070512154408.223236808@mvista.com>
In-Reply-To: <20070512154408.223236808@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705122058.35387.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 May 2007 17:43:46 Daniel Walker wrote:
> Considering that Andi has a similar patch, I'm going to assume there
> is already justification for this..

I just have a patch for sched_clock, which is somewhat different.

> What it ends up doing is allows the TSC to be used in cases which
> we didn't use it before, and hope it's still mostly accurate.

Yes the current code is badly broken in this regard. e.g. i always
hated that it always falls back on powernow systems.

Jiri will hopefully repost his true per CPU TSC patch soon, that should
make it all obsolete.

-Andi
