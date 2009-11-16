Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbZKPTcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbZKPTcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 14:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZKPTcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 14:32:39 -0500
Received: from mail.bluehost.com ([74.220.195.75]:43744 "HELO
	mail.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752095AbZKPTci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 14:32:38 -0500
Message-ID: <4B01A8DB.6090002@bluehost.com>
Date: Mon, 16 Nov 2009 12:32:43 -0700
From: Spencer Candland <spencer@bluehost.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] fix granularity of task_u/stime(), v2
References: <4AF8FD3C.2090008@jp.fujitsu.com> <4AF8FE76.406@jp.fujitsu.com> <20091111121150.GA2549@dhcp-lab-161.englab.brq.redhat.com> <4AFB5019.7030901@jp.fujitsu.com> <4AFB77C2.8080705@jp.fujitsu.com> <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com> <4AFB8C21.6080404@jp.fujitsu.com> <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com> <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com>
In-Reply-To: <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Stanislaw Gruszka wrote:
> Ok, I'm going to post this.
> 
> Spencer,
> 
> seems you have more test cases for utime decreasing issues,
> could you send links to me ? Somehow I could not find them 
> by my own. Particularly test case used in development this commit
> is interested:
> 
>   commit 49048622eae698e5c4ae61f7e71200f265ccc529
>   Author: Balbir Singh <balbir@linux.vnet.ibm.com>
>   Date:   Fri Sep 5 18:12:23 2008 +0200
>     sched: fix process time monotonicity

I had originally noticed that in a production web server, so my test
case was designed to mirror what I was seeing there, which was just
running apache with worker mpm, and running a simple apache bench while
watching the utime/stime of the apache children.  Unfortunately that
method was not terribly reliable at reproducing the issue, which is why
I felt it necessary to try to come up with a better test case this time
around.

- Spencer
