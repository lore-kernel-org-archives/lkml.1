Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbZEHFNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbZEHFNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 01:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZEHFNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 01:13:43 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44714 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbZEHFNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 01:13:42 -0400
Date: Fri, 8 May 2009 10:43:34 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, systemtap@sources.redhat.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -rc] [BUGFIX] kprobes: fix to use text_mutex around
	arm/disarmkprobe
Message-ID: <20090508051334.GA4453@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20090507203126.5399.97658.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507203126.5399.97658.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 04:31:26PM -0400, Masami Hiramatsu wrote:
> Fix kprobes to lock text_mutex around some arch_arm/disarm_kprobe() which
> are newly added by commit de5bd88d5a5cce3cacea904d3503e5ebdb3852a2.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
 
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
