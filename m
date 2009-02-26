Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbZBZWOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbZBZWOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbZBZWOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:14:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792AbZBZWOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:14:16 -0500
Date: Thu, 26 Feb 2009 14:12:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oleg Nesterov <oleg@redhat.com>
cc: Roland McGrath <roland@redhat.com>,
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
In-Reply-To: <20090226215945.GA12520@redhat.com>
Message-ID: <alpine.LFD.2.00.0902261410581.3111@localhost.localdomain>
References: <20090225190211.GA7445@redhat.com> <20090225193927.1ED25FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902251156160.3111@localhost.localdomain> <20090225212039.GA11883@redhat.com> <20090226215945.GA12520@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Feb 2009, Oleg Nesterov wrote:
> 
> Really, how CLONE_PARENT + exit_signal==0 can be useful?

Umm? For the reason I already stated?

> But because the current behaviour is just silly. Imho.

So? If there are people using it, you calling it silly is immaterial.

The fact is, it's an existing user space interface. We don't break them. 

> But of course, if this change can break the user-space applications, then
> it should not be applied.

That's the point. Nobody has shown that there aren't any users.

		Linus
