Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbYE3PTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbYE3PTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 11:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYE3PTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 11:19:10 -0400
Received: from xenotime.net ([66.160.160.81]:36958 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752606AbYE3PTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 11:19:09 -0400
Date: Fri, 30 May 2008 08:32:51 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Paul Jackson <pj@sgi.com>
Cc: miaox@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH 1/2] cpusets: restructure the function
 update_cpumask() and update_nodemask()
Message-Id: <20080530083251.8f06e092.rdunlap@xenotime.net>
In-Reply-To: <20080530012537.87454a8d.pj@sgi.com>
References: <483E564A.5050807@cn.fujitsu.com>
	<20080529031656.cdc38001.pj@sgi.com>
	<483F5DAA.5060004@cn.fujitsu.com>
	<20080529205344.4ba1efdb.pj@sgi.com>
	<483F6367.1040701@cn.fujitsu.com>
	<20080529212211.0e794c81.pj@sgi.com>
	<20080529203042.19f76f09.rdunlap@xenotime.net>
	<20080529225708.74f65654.pj@sgi.com>
	<20080529212746.2d9cae24.rdunlap@xenotime.net>
	<20080530012537.87454a8d.pj@sgi.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 01:25:37 -0500 Paul Jackson wrote:

> Randy wrote:
> > Does that help?  your understanding of kernel-doc or your decision?
> 
> Well, I get the difference between E (exported) and I (non-exported)
> now.  And I see that one could prepare documents using SGML templates
> that contained one, or the other of these, for any kernel source files
> of interest.
> 
> I'm stuck on the next step of this decision.
> 
> Usually, when I am preparing documens, I know what document I am
> preparing and have an idea who is in its audience.
> 
> I have never seen or heard of a document using the "/**" kernel-doc
> entries of kernel/cpuset.c, and I have no idea who actually has (in
> the past or present, not just hypothetically) read such or why.

You are certainly welcome to add kernel/cpuset.c to kernel-api.tmpl or any other
appropriate docbook file.  I have been known to do things like that as well.  :)

> So I'm kinda shootin in the dark here.
> 
> So, mostly just to be consistent with my previous call, because I enjoy
> being a stubborn retard, I continue to prefer that file static routines
> in kernel/cpuset.c not have "/**" kernel-doc markers on their comments,
> and I would still welcome a patch from Miao removing the ones already
> there.
> 
> Enough of this discussion, from me at least.


---
~Randy
"He closes his eyes and drops the goggles.  You can't get hurt
by looking at a bitmap.  Or can you?"
