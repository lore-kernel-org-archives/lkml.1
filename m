Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403Ab0AYVBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab0AYVBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624Ab0AYVBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:01:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51984 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab0AYVBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:01:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David <david@unsolicited.net>
Subject: Re: [Bug #14924] Weird hard hangs when rendering 'some' web-sites in Firefox
Date: Mon, 25 Jan 2010 22:02:26 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <20100125135531.GB3749@hack> <4B5DF061.1070704@unsolicited.net>
In-Reply-To: <4B5DF061.1070704@unsolicited.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001252202.26331.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, David wrote:
> Américo Wang wrote:
> > On Sun, Jan 24, 2010 at 11:04:33PM +0100, Rafael J. Wysocki wrote:
> >   
> >> This message has been generated automatically as a part of a report
> >> of recent regressions.
> >>
> >> The following bug entry is on the current list of known regressions
> >>     
> > >from 2.6.32.  Please verify if it still should be listed and let me know
> >   
> >> (either way).
> >>
> >>
> >> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14924
> >> Subject		: Weird hard hangs when rendering 'some' web-sites in Firefox
> >> Submitter	: David <david@unsolicited.net>
> >> Date		: 2009-12-21 21:53 (35 days old)
> >> References	: http://marc.info/?l=linux-kernel&m=126143375823340&w=4
> >>     
> >
> > Hmm, you have CONFIG_DETECT_SOFTLOCKUP=y, I have no idea what happened,
> > doing a bisect would be appreciated.
> >
> > Thanks.
> >
> >   
> 
> I no longer have the offending hardware, but I think that the issue was
> probably corrected by:
> 
>     cafe6609d6dc0a6a278f9fdbb59ce4d761a35ddd -
> drm/radeon/kms: Schedule host path read cache flush through the ring V2
> 
> as the offending ATI graphics was indeed R300.

Well, let's assume that's really the case.  Closed.

Rafael
