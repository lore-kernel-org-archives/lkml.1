Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZEDRfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZEDRfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758591AbZEDRfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:35:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758595AbZEDRfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:35:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
In-Reply-To: Oleg Nesterov's message of  Sunday, 3 May 2009 22:21:00 +0200 <20090503202100.GC18889@redhat.com>
References: <20090428223025.GA11997@redhat.com>
	<20090501000222.8BACEFC3BF@magilla.sf.frob.com>
	<20090503202100.GC18889@redhat.com>
X-Windows: ignorance is our most important resource.
Message-Id: <20090504173422.45B9FFC32F@magilla.sf.frob.com>
Date: Mon,  4 May 2009 10:34:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 04/30, Roland McGrath wrote:
> >
> > This is related to the issue of racing stop signals lost by de_thread().
> > That is still on our back-burner list to think about more deeply one day.
> 
> Hmm. did you mean "lost by selinux_bprm_committed_creds()" ?

No, that is the separate issue we are dealing with now.

> Or do we really have some problems with SIGSTOP && de_thread() ?

Yes, this is an old subject (you've forgotten! ;-) and not really apropos
to this thread.  Let's discuss it separately (and like I said, not a top
priority right now).  (The problem is with another thread having just
dequeued a stop signal when exec comes along.)


Thanks,
Roland
