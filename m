Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYLGCTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYLGCTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 21:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYLGCS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 21:18:58 -0500
Received: from outbound-mail-159.bluehost.com ([67.222.39.39]:47952 "HELO
	outbound-mail-159.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753000AbYLGCS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 21:18:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=QqHLseAL74BlgqSLTsJCdAnhItQGPYFsfsABtNUV942LYPWB6y+Zfx98ijj91WqED77xIg0q2UlcAiuWEjnehBfNN3gouGdnBQ6BwgBuUE7jYyXIB2wRk4fv5M/XmHik;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/3] PCI: Suspend and resume PCI Express ports with interrupts disabled
Date: Sat, 6 Dec 2008 18:18:54 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812060933430.3425@nehalem.linux-foundation.org> <200812061846.12167.rjw@sisk.pl>
In-Reply-To: <200812061846.12167.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812061818.55115.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 6, 2008 9:46 am Rafael J. Wysocki wrote:
> On Saturday, 6 of December 2008, Linus Torvalds wrote:
> > On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> > > I think it should go through Jesse?
> >
> > Probably correct. And we want it in -next, so that it can get some
> > testing even before I open the merge window. Because I hope everybody
> > realizes that there's no way we're doing this in 2.6.28, and we'll leave
> > the broken and unreliable suspend.
> >
> > Because afaik this is not a new bug (I tried to push a patch to do
> > suspend_late/resume_early for the PCI code a _loong_ time ago, but it
> > never got merged), and the only reason it showed up as a regression was
> > almost certainly simply that we've always had this.
> >
> > IOW, suspend/resume has always been dodgy wrt interrupts, and there's
> > some luck involved. And your machine just happened to get unlucky.
> >
> > I'd love to fix this in 2.6.28, but it's just not reasonable - it needs
> > widespread testing with an early -rc merge. And if it turns out to fix a
> > lot of machines, and there are no regressions, we can always back-port it
> > later.
>
> I agree.

I'll stuff it into my -next branch tonight.

-- 
Jesse Barnes, Intel Open Source Technology Center

