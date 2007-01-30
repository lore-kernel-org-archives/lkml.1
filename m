Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbXA3XqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbXA3XqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXA3XqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:46:24 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:50194 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbXA3XqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:46:20 -0500
In-Reply-To: <Pine.LNX.4.64.0701301448320.3611@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <Pine.LNX.4.64.0701301345060.3611@woody.linux-foundation.org> <0E1E87C3-954C-4297-9D6C-E98BC79D68C3@oracle.com> <Pine.LNX.4.64.0701301448320.3611@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <00CAB6CF-640D-4449-9CBA-7E52FE9BEC37@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Date: Tue, 30 Jan 2007 15:45:45 -0800
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Btw, I noticed that you didn't Cc Ingo. Definitely worth doing. Not  
> just
> because he's basically the normal scheduler maintainer, but also  
> because
> he's historically been involved in things like the async filename  
> lookup
> that the in-kernel web server thing used.

Yeah, that was dumb.  I had him in the cc: initially, then thought it  
was too large and lobbed a bunch off.  My mistake.

Ingo, I'm interested in your reaction to the i386-specific mechanics  
here (the thread_info copies terrify me) and the general notion of  
how to tie this cleanly into the scheduler.

- z
