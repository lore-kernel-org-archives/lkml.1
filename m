Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbZBZWd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbZBZWd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbZBZWds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:33:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46549 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbZBZWdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:33:47 -0500
Date: Thu, 26 Feb 2009 23:30:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] copy_process: fix CLONE_PARENT && ->exit_signal
	interaction
Message-ID: <20090226223031.GA14477@redhat.com>
References: <20090225190211.GA7445@redhat.com> <20090225193927.1ED25FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902251156160.3111@localhost.localdomain> <20090225212039.GA11883@redhat.com> <20090226215945.GA12520@redhat.com> <alpine.LFD.2.00.0902261410581.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902261410581.3111@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Linus Torvalds wrote:
>
> On Thu, 26 Feb 2009, Oleg Nesterov wrote:
> >
> > Really, how CLONE_PARENT + exit_signal==0 can be useful?
>
> Umm? For the reason I already stated?

But I can not understand that reason... As I said, the thread does not
go away if exit_signal == 0. Yes, the parent does not see it has a new
zombie, but why this is useful?

> > But because the current behaviour is just silly. Imho.
>
> So? If there are people using it, you calling it silly is immaterial.
>
> The fact is, it's an existing user space interface. We don't break them.
>
> > But of course, if this change can break the user-space applications, then
> > it should not be applied.
>
> That's the point. Nobody has shown that there aren't any users.

Yes, yes, sure...

I sent another patch, perhaps someone can comment. Or suggest something
else.

Oleg.

