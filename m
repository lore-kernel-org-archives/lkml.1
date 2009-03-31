Return-Path: <linux-kernel-owner+w=401wt.eu-S1761961AbZCaR6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761961AbZCaR6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 13:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbZCaR55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 13:57:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53211 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757033AbZCaR55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 13:57:57 -0400
Message-ID: <49D259BD.1010402@redhat.com>
Date: Tue, 31 Mar 2009 13:58:21 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: ananth@in.ibm.com, fche@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [BUGFIX] request for picking fee039a1 up (Re: fee039a1 and ccbeed3a
 dependency)
References: <20090331031822.GG6411@in.ibm.com>
In-Reply-To: <20090331031822.GG6411@in.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Since the commit ccbeed3a changed pt_regs, kretprobe has to be
updated (which was done by commit fee039a1) too.

Could you pick up the commit fee039a1 from Ingo's -tip tree or
linux-next?

Thank you,

Ananth N Mavinakayanahalli wrote:
> Hi Ingo,
> 
> Commit ccbeed3a introduced a new element (gs) to pt_regs and that broke
> the kretprobe booster for x86_32. Masami has fixed that and it is in
> -tip as fee039a1.
> 
> As of today, it looks like ccbeed3a is upstream while fee039a1 isn't yet
> there.
> 
> Request you to push fee039a1 with your next set of updates please :-)
> 
> Regards,
> Ananth 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


