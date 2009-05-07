Return-Path: <linux-kernel-owner+w=401wt.eu-S1759933AbZEGI7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933AbZEGI7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbZEGI6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:58:54 -0400
Received: from sous-sol.org ([216.99.217.87]:37685 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754245AbZEGI6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:58:54 -0400
Date: Thu, 7 May 2009 01:57:42 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH 3/3a] ptrace: add _ptrace_may_access()
Message-ID: <20090507085742.GB3036@sequoia.sous-sol.org>
References: <20090505224729.GA965@redhat.com> <20090506080050.GF17457@elte.hu> <20090506235349.GC3756@redhat.com> <20090507002133.02D05FC39E@magilla.sf.frob.com> <20090507063606.GA15220@redhat.com> <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com> <20090507083851.GA19133@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507083851.GA19133@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> * Oleg Nesterov <oleg@redhat.com> wrote:
> > Agreed, but what about security_operations->ptrace_may_access ?
> > It has the same (bad) name, but returns the error code or 0 on 
> > success.
> 
> Bad code should generally be fixed, or in exceptional circumstances 
> it can tolerated if it's pre-existing bad code, but it should never 
> be propagated. It has not spread _that_ widely yet, and is isolated 
> to the security subsystem:

And the security hooks tend to all follow the 0 success -ve ERR on error.
