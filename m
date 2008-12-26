Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbYLZDDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbYLZDDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 22:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYLZDC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 22:02:57 -0500
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:47109 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214AbYLZDC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 22:02:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=L54FHzoWJeQTZt+1C9OeUlyCwkuppzg47RnfqBoVcGPWNXENKLNw3Qz07SzqNOnX;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Thu, 25 Dec 2008 22:02:44 -0500
From: Bill Fink <billfink@mindspring.com>
To: Bill Fink <billfink@mindspring.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 2/2] ieee1934: dv1394 interrupt enabling/disabling
 broken on big-endian
Message-Id: <20081225220244.1eacb39d.billfink@mindspring.com>
In-Reply-To: <20081223172300.5bd19846.billfink@mindspring.com>
References: <1229210489.11257.16.camel@brick>
	<4944561D.4010608@s5r6.in-berlin.de>
	<20081213204137.d150645c.billfink@mindspring.com>
	<49446923.5040606@s5r6.in-berlin.de>
	<20081223172300.5bd19846.billfink@mindspring.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4d0a49f46528c580e87bc6c0f40d43b905350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 96.234.158.88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2008, Bill Fink wrote:

> On Sun, 14 Dec 2008, Stefan Richter wrote:
> 
> > Bill Fink wrote:
> > > On Sun, 14 Dec 2008, Stefan Richter wrote:
> > >> Looks like a bug + correct fix indeed.  Apparently dv1394 was never used on big
> > >> endian PCs.
> > ...
> > > I use dv1394 on a big-endian PPC system (2.6.15 kernel) to watch DV video
> > > via xine, and this has always worked fine for me.
> > 
> > Could you try to apply the patch to your kernel to test it?  You can get
> > it in plaintext e.g. from
> > http://user.in-berlin.de/~s5r6/linux1394/submitted/843-ieee1934-dv1394-interrupt-enabling_disabling-broken-on-big-endian.patch
> 
> I had hoped to test this by now, but due to not feeling well and the
> holidays, I haven't been able to.  I still hope to test this later,
> but I can't say exactly when.

Good news.  I finally got a chance to test the patch on my kernel,
and live DV viewing using xine still worked fine.

						-Thanks

						-Bill
