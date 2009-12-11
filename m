Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbZLKOjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbZLKOjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757760AbZLKOjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:39:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52490 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757610AbZLKOjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:39:22 -0500
X-Authority-Analysis: v=1.0 c=1 a=CScyToYBCoIA:10 a=7U3hwN5JcxgA:10 a=HHt0f0CujJhU5CPM7swA:9 a=VynWkbcyoFg0FFc-FpRBLBUryDMA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH]tracing: Fix inaccurate function definition in
 trace_events_filter.c
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Wenji Huang <wenji.huang@oracle.com>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com
In-Reply-To: <4B21FF84.3010509@cn.fujitsu.com>
References: <1260518338-16034-1-git-send-email-wenji.huang@oracle.com>
	 <4B21FF84.3010509@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 11 Dec 2009 09:39:24 -0500
Message-ID: <1260542364.2146.351.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 16:15 +0800, Li Zefan wrote:
> Wenji Huang wrote:
> > Use strcmp instead of strncmp to do full match.
> > 
> 
> It's intended to use strncmp instead of strcmp..
> 
> field(char, name, size) will be treated as a STATIC_STRING by
> filter code. But this field isn't necessarily a string, it
> can be an array of chars, which may not be ended with '\0'.
> So in this case, we can't use strcmp.
> 
> So do you really see incorrect filter results?

Yeah, I agree that this should be strncmp. Have you seen errors?

-- Steve


