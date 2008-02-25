Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbYBYXyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbYBYXyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbYBYXyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:54:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33057 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbYBYXyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:54:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [xfs-masters] filesystem corruption on xfs after 2.6.25-rc1 (bisected, powerpc related?)
Date: Tue, 26 Feb 2008 00:52:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, johannes@sipsolutions.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080225112310.GA5516@soziologie.ch> <200802260042.35918.rjw@sisk.pl> <47C353D4.1060501@sandeen.net>
In-Reply-To: <47C353D4.1060501@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802260052.57875.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 26 of February 2008, Eric Sandeen wrote:
> Rafael J. Wysocki wrote:
> > On Monday, 25 of February 2008, Eric Sandeen wrote:
> 
> 
> >> If you're feeling motivated, maybe you can narrow it down to which of
> >> the changes - xfs_highbit32, xfs_highbit64, xfs_lowbit32, or
> >> xfs_lowbit64 - is causing the problem?  (or maybe they all are ...)
> >>
> >> Or maybe someone looking at the commit can immediately see the
> >> problem... but I can't :)
> > 
> > Well, IMO a reproducible filesystem corruption is a serious enough issue
> > for reverting all of the commits in question.
> 
> I'm not suggesting a partial revert; I just wonder which part of the
> change is causing the problem, as part of the debugging process.

Understood.

My point is, if that's not practical (whatever the reason), I'd consider
reverting all of the commits in question.

Thanks,
Rafael
