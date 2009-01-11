Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbZAKSlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbZAKSlx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 13:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbZAKSln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 13:41:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37956 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbZAKSlm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 13:41:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Fran=C3=A7ois_Valenduc?= 
	<francois.valenduc@tvcablenet.be>
Subject: Re: [Bug #12216] Error when drm is loaded
Date: Sun, 11 Jan 2009 19:41:19 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, Keith Packard <keithp@keithp.com>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera> <nHCfeC0YLrE.A.35C.HbfaJB@chimera> <496A073D.4070804@tvcablenet.be>
In-Reply-To: <496A073D.4070804@tvcablenet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901111941.20426.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 January 2009, François Valenduc wrote:
> Rafael J. Wysocki a écrit :
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12216
> > Subject		: Error when drm is loaded
> > Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
> > Date		: 2008-12-13 09:59 (30 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=52440211dcdc52c0b757f8b34d122e11b12cdd50
> >
> >
> >
> >   
> This problem has been solved by the following patch:
> 
> commit 077ebed54fe66612f58b076628a72eca2be8df90
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Mon Dec 22 17:11:02 2008 +1000
> 
>     drm/radeon: fix correctness of irq_enabled check for radeon.
> 
> 
> This fix is in kernel 2.6.28, so this bug can be removed from the
> regression list.

Thanks, closed.

Rafael
