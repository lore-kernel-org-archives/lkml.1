Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbYLWWXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbYLWWXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 17:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYLWWXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 17:23:04 -0500
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:56317 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbYLWWXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 17:23:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=hTrXKUl4dHFUaiLFiwNpiXXJkmXXyV1iReIfEwvqdvKu3NN0yPOrLKA1Vy4YTROe;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Tue, 23 Dec 2008 17:23:00 -0500
From: Bill Fink <billfink@mindspring.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 2/2] ieee1934: dv1394 interrupt enabling/disabling
 broken on big-endian
Message-Id: <20081223172300.5bd19846.billfink@mindspring.com>
In-Reply-To: <49446923.5040606@s5r6.in-berlin.de>
References: <1229210489.11257.16.camel@brick>
	<4944561D.4010608@s5r6.in-berlin.de>
	<20081213204137.d150645c.billfink@mindspring.com>
	<49446923.5040606@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4ddf3f99fd3968251ddd7ed4fa43a0be0d350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 96.234.158.88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2008, Stefan Richter wrote:

> Bill Fink wrote:
> > On Sun, 14 Dec 2008, Stefan Richter wrote:
> >> Looks like a bug + correct fix indeed.  Apparently dv1394 was never used on big
> >> endian PCs.
> ...
> > I use dv1394 on a big-endian PPC system (2.6.15 kernel) to watch DV video
> > via xine, and this has always worked fine for me.
> 
> Could you try to apply the patch to your kernel to test it?  You can get
> it in plaintext e.g. from
> http://user.in-berlin.de/~s5r6/linux1394/submitted/843-ieee1934-dv1394-interrupt-enabling_disabling-broken-on-big-endian.patch

I had hoped to test this by now, but due to not feeling well and the
holidays, I haven't been able to.  I still hope to test this later,
but I can't say exactly when.

					-Happy Holidays to all

					-Bill
