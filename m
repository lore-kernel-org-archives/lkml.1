Return-Path: <linux-kernel-owner+w=401wt.eu-S1761701AbZBEBJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761701AbZBEBJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759590AbZBEBIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:08:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49129 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932097AbZBEBIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:08:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Justin Mattock <justinmattock@gmail.com>
Subject: Re: [Bug #12505] 2.6.29-rc1 Firefox crashing on page load
Date: Thu, 5 Feb 2009 02:08:14 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Justin Madru <jdm64@gawab.com>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <20090204164623.GE25996@elte.hu> <dd18b0c30902041015m2213d94cx72d41bd225afa3e9@mail.gmail.com>
In-Reply-To: <dd18b0c30902041015m2213d94cx72d41bd225afa3e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050208.15776.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Justin Mattock wrote:
> On Wed, Feb 4, 2009 at 4:46 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Justin Mattock <justinmattock@gmail.com> wrote:
> >
> >> On Wed, Feb 4, 2009 at 2:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > This message has been generated automatically as a part of a report
> >> > of recent regressions.
> >> >
> >> > The following bug entry is on the current list of known regressions
> >> > from 2.6.28.  Please verify if it still should be listed and let me know
> >> > (either way).
> >> >
> >> >
> >> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12505
> >> > Subject         : 2.6.29-rc1 Firefox crashing on page load
> >> > Submitter       : Justin Madru <jdm64@gawab.com>
> >> > Date            : 2009-01-16 20:56 (20 days old)
> >> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4217458dafaa57d8e26a46f5d05ab8c53cf64191
> >> > References      : http://marc.info/?l=linux-kernel&m=123213941914274&w=4
> >> > Handled-By      : Justin P. Mattock <justinmattock@gmail.com>
> >> >
> >> >
> >> >
> >>
> >> Well the hardest for this, was to reproduce
> >> the error.(never did). I guess it can be taken
> >> of if there was a patch for the fix, and the patch
> >> made it into the main tree. but if this  is a firefox
> >> issue, then a report needs to be filed with them.
> >> so overall my answer is "I don't know."
> >> :^)
> >
> > the error is spurious because gcc randomly stomps on user register state so
> > the effects can be rather random and unpredictable.
> >
> > The fix:
> >
> >  552b8aa: Revert "x86: signal: change type of paramter for sys_rt_sigreturn()"
> >
> > was included in -rc2 already, so please test latest -git whether you can see
> > any such troubles.
> >
> >        Ingo
> >
> 
> Sure I'll test it.
> I'm just in the process of compiling libc.
> which looks like I'll be here for a while.

I've closed the bug as hopefully fixed.

Thanks,
Rafael
