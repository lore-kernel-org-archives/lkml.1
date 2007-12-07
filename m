Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbXLGXY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbXLGXY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbXLGXYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:24:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37887 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbXLGXYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:24:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Date: Sat, 8 Dec 2007 00:43:28 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, gnome42@gmail.com,
       linux-kernel@vger.kernel.org, bfields@fieldses.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Denis V. Lunev" <den@openvz.org>
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com> <1197067918.10831.13.camel@heimdal.trondhjem.org> <20071207151444.af5d8e11.akpm@linux-foundation.org>
In-Reply-To: <20071207151444.af5d8e11.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712080043.29292.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 8 of December 2007, Andrew Morton wrote:
> On Fri, 07 Dec 2007 17:51:58 -0500
> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > 
> > On Fri, 2007-12-07 at 14:39 -0500, Shane wrote:
> > > On Dec 7, 2007 2:16 PM, Shane <gnome42@gmail.com> wrote:
> > > ...
> > > > Confirmed working in rc4-git5.  I'll deploy this kernel in a few more
> > > > spots and check for other regressions.
> > > 
> > > Hmm, I installed a new kernel built from the same sources on the NFS
> > > server. And now I don't see anything at all in the crossmnt dirs.
> > > 
> > > ls /dirA/dirB/dirC  --> zero output (empty dir)
> > > 
> > > Are there any other pending fixes?
> > > 
> > > Shane
> > 
> > You've probably fallen afoul of 
> > 
> >    http://bugzilla.kernel.org/show_bug.cgi?id=9504
> > 
> 
> Yeah.
> 
> I have a tentative fix below but I can't seem to get Eric and Denis to get
> a suitable fix nailed down.  It's urgent!

Well, how about asking Linus to revert commit
2b1e300a9dfc3196ccddf6f1d74b91b7af55e416 altogether and starting over again?

It apparently causes more trouble than the issue it was supposed to fix.

I've already reopened http://bugzilla.kernel.org/show_bug.cgi?id=9411 and I'll
regard it as unfixed from now on.
