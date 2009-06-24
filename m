Return-Path: <linux-kernel-owner+w=401wt.eu-S1751936AbZFXBJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbZFXBJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 21:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbZFXBJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 21:09:05 -0400
Received: from tundra.namei.org ([65.99.196.166]:45879 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbZFXBJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 21:09:03 -0400
Date: Wed, 24 Jun 2009 11:08:27 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-security-module@vger.kernel.org
Subject: Re: security: rename ptrace_may_access => ptrace_access_check
In-Reply-To: <20090623141451.GA8133@redhat.com>
Message-ID: <alpine.LRH.2.00.0906241103150.10746@tundra.namei.org>
References: <20090507063606.GA15220@redhat.com> <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com> <20090507083851.GA19133@elte.hu> <20090507085742.GB3036@sequoia.sous-sol.org> <20090507090459.GE19133@elte.hu> <20090507092009.GC3036@sequoia.sous-sol.org>
 <alpine.LRH.2.00.0905071951530.29219@tundra.namei.org> <20090507102015.GB8901@elte.hu> <alpine.LRH.2.00.0905072135580.29806@tundra.namei.org> <20090623141451.GA8133@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Oleg Nesterov wrote:

> On 05/07, James Morris wrote:
> >
> > On Thu, 7 May 2009, Ingo Molnar wrote:
> >
> > > > Boot tested with SELinux.
> > >
> > > thanks! Below are the two patches i wrote and tested.
> >
> > Do you need these in your tree, or are they ok going into linux-next via
> > mine?
> 
> James, Ingo, what happend with these renames? I don't see them
> in linux/kernel/git/jmorris/security-testing-2.6.git.

The context was probably lost for some reason, e.g. waiting on acks or for 
reviewer questions to be resolved.  Please resend if you don't see them 
applied and also always indicate any depdendencies on other patches.

It is unliklely that I'd apply security-related patches of any kind of 
non-trivial nature without reviewed-by or acked-by lines from other 
developers, and you may need to engage reviewers on an individual basis to 
make that happen.


- James
-- 
James Morris
<jmorris@namei.org>
