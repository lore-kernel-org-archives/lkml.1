Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbZKKD4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbZKKD4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 22:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZKKD4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 22:56:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:44263 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZKKD4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 22:56:02 -0500
Message-ID: <4AFA35CB.5030801@kernel.org>
Date: Wed, 11 Nov 2009 12:55:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
References: <4AF90254.40909@kernel.org> <alpine.LFD.2.01.0911100903370.31845@localhost.localdomain> <4AF9B1FD.1010408@kernel.org> <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain> <4AF9BE3A.40409@kernel.org> <20091110193705.GA9011@elte.hu> <4AF9C402.9040800@kernel.org> <alpine.LFD.2.01.0911101338190.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0911101338190.31845@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Linus Torvalds wrote:
> I want the cleanup because I think that the code sucks from a "future 
> proofing" and readability standpoint, but I really don't mind one way or 
> the other whether you want to finally do that one "return 1" correctly for 
> one commit, only to then fix it to not do that three-way test of a single 
> function in the next one.
> 
> So whatever works - as long as the end result both looks sane and doesn't 
> have the bug we clearly have now.

I was mostly worrying about introducing unrelated bug while changing.
Anyways, one patch it is.  I'll route it through tip as suggested by
Ingo in a few hours.

Thanks a lot.

-- 
tejun
