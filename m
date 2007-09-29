Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbXI2JgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbXI2JgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 05:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbXI2Jf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 05:35:58 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:43757 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbXI2Jf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 05:35:57 -0400
Date: Sat, 29 Sep 2007 11:35:53 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: regression in 2.6.23-rc8 - power off failed
Message-ID: <20070929093553.GA4451@erig.dyndns.org>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	Alexey Starikovskiy <astarikovskiy@suse.de>
References: <20070929005453.GA4475@erig.dyndns.org> <46FDC0EB.3070003@zytor.com> <20070929082233.GA3447@erig.dyndns.org> <46FE0D29.4090706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FE0D29.4090706@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 01:30:33AM -0700, H. Peter Anvin wrote:
> Wolfgang Erig wrote:
> > Both are bad.
> > Two different systems and two different bisections.
> > I sent the last step of each.
> 
> >>> $ git bisect good 
> >>> Bisecting: 0 revisions left to test after this 
> >>> [626073132b381684c4983e0d911e9aceb32e2cbc] Assembly header and main routine for new x86 setup code 
> >> OK, so which one is the bad one?
> > 
> > This problem (no power off) persists after pull some minutes ago.
> > Sorry for the confusion.
> > 
> 
> I believe there must have been something wrong here (possibly
> inconsistent experiments?)  This checkin has *zero code changes* from
> the previous one (and next one) -- the kernel should have been binarily
> identical to the previous one.  The code introduced in this checkin
> doesn't even get compiled until two checkins later,
> 4fd06960f120e02e9abc802a09f9511c400042a5.

I have done two bisections simultanously and it was late at night.
I start again with a fresh tree and better controlled experiments.

Wolfgang
