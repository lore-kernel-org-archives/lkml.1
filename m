Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753717AbYLRMwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbYLRMwj (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 07:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYLRMw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 07:52:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47065 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbYLRMw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 07:52:28 -0500
Date: Thu, 18 Dec 2008 13:52:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>, linux-arch@vger.kernel.org,
        Alexander van Heukelum <heukelum@mailshack.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 1/many] PROC macro to annotate functions in assembly
	files
Message-ID: <20081218125215.GB32135@elte.hu>
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm> <1229505475-10219-2-git-send-email-heukelum@fastmail.fm> <20081217172640.GB5436@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217172640.GB5436@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, Dec 17, 2008 at 10:17:54AM +0100, Alexander van Heukelum wrote:
> > Introduce the PROC macro in the generic header file
> > include/linux/linkage.h to annotate functions in assembly
> > files. This is a first step to fully annotate functions
> > (procedures) in .S-files. The PROC macro complements the
> > already existing and being used ENDPROC macro. The generic
> > implementation of PROC is exactly the same as ENTRY.
> > 
> > The goal is to annotate functions, at least those called
> > from C code, with PROC at the beginning and ENDPROC at the
> > end. This is for the benefit of debugging and tracing. It
> > will also allow to introduce a framework to check for
> > nesting problems and missing annotations in a later stage
> > by overriding ENTRY/END and PROC/ENDPROC in architecture-
> > specific code, after the annotation errors have been fixed.
> > 
> > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> I understand where you are coming from with these.
> But what I see now is:
> 
> ENTRY/END
> PROC/ENDPROC
> KPROBE_ENTRY/KPROBE_END

btw., KPROBE_ENTRY is an ugly euphemism. It should be renamed to 
NOKPROBE_ENTRY/NOKPROBE_END.

	Ingo
