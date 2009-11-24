Return-Path: <linux-kernel-owner+w=401wt.eu-S934183AbZKXVbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934183AbZKXVbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934074AbZKXVbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:31:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934044AbZKXVbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:31:12 -0500
Date: Tue, 24 Nov 2009 16:31:05 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, Ingo@firstfloor.org,
       "Molnar <mingo"@firstfloor.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091124213105.GG29296@redhat.com>
References: <20091124200220.GA5828@redhat.com> <87my2bwtno.fsf@basil.nowhere.org> <20091124204152.GA9131@redhat.com> <20091124212619.GB29096@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124212619.GB29096@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Nov 24, 2009 at 10:26:19PM +0100, Andi Kleen wrote:
> [...]
> > For example. tracehook_report_syscall_entry() has a lot of callers
> > in arch/, each callsite should be changed to do
> > 
> > 	if ((task_utrace_flags(current) & UTRACE_EVENT(SYSCALL_ENTRY)) &&
> > 		utrace_report_syscall_entry(regs))
> > 		ret = -1; // this depends on machine
> > 
> > instead of simply calling tracehook_report_syscall_entry().
> 
> That should be in the utrace code?
> 
> I don't have a problem with having common code somewhere,
> just not a whole layer whose only purpose seems to be obfuscation.

One man's obfuscation is another man's abstraction.
Would you be satisfied if "tracehook_" was renamed "utracehook_"?


- FChE
