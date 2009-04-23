Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbZDWAsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbZDWAsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbZDWAsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:48:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38992 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbZDWAsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:48:11 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Larry Woodman <lwoodman@redhat.com>
Subject: Re: [Patch] mm tracepoints update - use case.
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       =?ISO-2022-JP?B?RnIbJEJxRXFTGyhCaWM=?= Weisbecker 
	<fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, riel@redhat.com, rostedt@goodmis.org
In-Reply-To: <1240428151.11613.46.camel@dhcp-100-19-198.bos.redhat.com>
References: <1240402037.4682.3.camel@dhcp47-138.lab.bos.redhat.com> <1240428151.11613.46.camel@dhcp-100-19-198.bos.redhat.com>
Message-Id: <20090423092933.F6E9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu, 23 Apr 2009 09:48:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2009-04-22 at 08:07 -0400, Larry Woodman wrote:
> > On Wed, 2009-04-22 at 11:57 +0200, Ingo Molnar wrote:
> > > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > > In past thread, Andrew pointed out bare page tracer isn't useful. 
> > > 
> > > (do you have a link to that mail?)
> > > 
> > > > Can you make good consumer?
> > 
> > I will work up some good examples of what these are useful for.  I use
> > the mm tracepoint data in the debugfs trace buffer to locate customer
> > performance problems associated with memory allocation, deallocation,
> > paging and swapping frequently, especially on large systems.
> > 
> > Larry
> 
> Attached is an example of what the mm tracepoints can be used for:

I have some comment.

1. Yes, current zone_reclaim have strange behavior. I plan to fix
   some bug-like bahavior.
2. your scenario only use the information of "zone_reclaim called".
   function tracer already provide it.
3. but yes, you are going to proper direction. we definitely need
   some fine grained tracepoint in this area. we are welcome to you.
   but in my personal feeling, your tracepoint have worthless argument
   a lot. we need more good information.
   I think I can help you in this area. I hope to work together.







