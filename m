Return-Path: <linux-kernel-owner+w=401wt.eu-S1759911AbZBYTsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911AbZBYTsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 14:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbZBYTsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 14:48:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53123 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757023AbZBYTsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 14:48:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] exit_notify: kill the wrong capable(CAP_KILL) check
In-Reply-To: Oleg Nesterov's message of  Wednesday, 25 February 2009 20:02:18 +0100 <20090225190218.GA7453@redhat.com>
References: <20090225190218.GA7453@redhat.com>
X-Windows: form follows malfunction.
Message-Id: <20090225194140.D6F6EFC3DA@magilla.sf.frob.com>
Date: Wed, 25 Feb 2009 11:41:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I can't understand why exit_notify() checks capable(CAP_KILL), but this
> looks just wrong.

I don't know either why it's there.  My guess is that it was not actually
thought out specifically, just a "unless capable" exception added when the
security-motivated exclusions (exec_id stuff) were added.

I can't think of any reason not to drop this check.


Thanks,
Roland
