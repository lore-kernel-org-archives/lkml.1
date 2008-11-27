Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbYK0DLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbYK0DLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 22:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYK0DLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 22:11:42 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:54536 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYK0DLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 22:11:42 -0500
Message-ID: <492E0FD2.8040805@oracle.com>
Date: Wed, 26 Nov 2008 19:11:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 0/1] ring-buffer fix for 2.6.28
References: <20081127025227.026028481@goodmis.org>
In-Reply-To: <20081127025227.026028481@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.492E0FD6.0038:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> The following patch needs to go into 2.6.28. It protects against
> a recursion race that can happen when the scheduler is traced.
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: devel
> 
> 
> Lai Jiangshan (1):
>       ring-buffer: prevent recursion
> 
> ----
>  kernel/trace/ring_buffer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Is there something about git that causes (or forces) the use of
patch 0/1 followed by patch 1/1?  I find it terribly unwanted.

thanks,
-- 
~Randy
