Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYBCVTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYBCVTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 16:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYBCVS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 16:18:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41526 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYBCVS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 16:18:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/4] x86 PM: Consolidate suspend and hibernation code
Date: Sun, 3 Feb 2008 22:16:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
References: <200802032141.56887.rjw@sisk.pl> <20080203211519.GA27737@elte.hu>
In-Reply-To: <20080203211519.GA27737@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802032216.57391.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 3 of February 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > This series of patches consolidates the x86 suspend and hibernation code.
> > It does the following:
> > - move 64-bit hibernation/suspend files to arch/x86/power (under different
> >   names)
> > - rename 32-bit files in arch/x86/power in line with the 64-bit files
> > - separate hibernation-specific 64-bit code from the code used for both
> >   suspend and hibernation and simplify the Makefile
> > - fix up comments
> > Details are in the changelogs.
> > 
> > These patches don't introduce any functional changes.
> 
> looks sane to me - i've applied them to x86.git. Is it fine with you if 
> we push them upstream (barring any test failures)?

Yes, it is. :-)

Thanks,
Rafael
