Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758695AbYLQMGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbYLQMGl (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYLQMG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:06:28 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:1768 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYLQMG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:06:28 -0500
Date: Wed, 17 Dec 2008 13:04:50 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH last/many] x86: checking framework for correct use of ENTRY/PROC
Message-ID: <20081217120450.GA8600@mailshack.com>
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm> <1229505475-10219-2-git-send-email-heukelum@fastmail.fm> <1229505475-10219-3-git-send-email-heukelum@fastmail.fm> <aa79d98a0812170351rb64c595gc933456c661317c5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa79d98a0812170351rb64c595gc933456c661317c5@mail.gmail.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Wed, 17 Dec 2008 13:06:15 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.45; VDF: 7.1.0.245; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 02:51:53PM +0300, Cyrill Gorcunov wrote:
> On Wed, Dec 17, 2008 at 12:17 PM, Alexander van Heukelum
> <heukelum@fastmail.fm> wrote:
> > [ DO NOT APPLY (yet...) At this point this patch will
> > just cause the build to abort due to annotation errors
> > found. ]
> >
> > Introduce a checking framework to check correct pairing
> > of ENTRY/END and PROC/ENDPROC. It also checks that the
> > annotations are not nested. I have used the ideas and
> > most of the implementation from Cyrill Gorcunov who
> > introduced the framework to check for mismatching
> > KPROBE_ENTRY annotations, which was however soon made
> > obsolete by the removal of KPROBE_ENTRY/KPROBE_END.
> >
> > Checks performed:
> >  o  END must terminate an ENTRY annotation
> >  o  ENDPROC must terminate a PROC annotation
> >  o  ENTRY or PROC cannot be nested inside
> >        another ENTRY or PROC section.
> >
> > Finally the macro ENTRY_PROC_FINAL is introduced to
> > enable checking correct closing of PROC and ENTRY
> > sections at the end of assembly files.
> >
> > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> > Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> ...
> 
> Thanks Alexander!
> 
> You know I think you meant __ASSEMBLY__ while
> were typing __ASSEMBLER__. Don't you? :)

If it matters there is some cleanup to do in the kernel tree ;).

Greetings,
    Alexander
