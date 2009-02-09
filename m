Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZBIPWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZBIPWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 10:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZBIPWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 10:22:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36855 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbZBIPWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:22:38 -0500
Date: Mon, 9 Feb 2009 10:22:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 0/2] git pull request for tip/tracing/urgent
In-Reply-To: <20090209151744.459736868@goodmis.org>
Message-ID: <alpine.DEB.1.10.0902091021540.14528@gandalf.stny.rr.com>
References: <20090209151744.459736868@goodmis.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 9 Feb 2009, Steven Rostedt wrote:
> Here's the changes by Lai. The bug scared me enough to investigate
> it further, to see if we had other bug reports that this could
> have fixed. But I found out that ring_buffer_read_page currently
> does not have any users. The only user I have is for my splice work,
> which has not been included yet.

Note, this may explain some of the bugs I've seen in my splice code. I 
just assumed it was my splice code that was broken, not the ring buffer 
;-)

-- Steve

