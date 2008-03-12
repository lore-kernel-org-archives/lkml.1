Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbYCLRaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbYCLRaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYCLR37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:29:59 -0400
Received: from phunq.net ([64.81.85.152]:45057 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751797AbYCLR36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:29:58 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Wed, 12 Mar 2008 09:29:53 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803102050.40567.phillips@phunq.net> <20080312131133.60e99d29@the-village.bc.nu>
In-Reply-To: <20080312131133.60e99d29@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121029.54108.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 06:11, Alan Cox wrote:
> > > Ext3 is only going to help you if the ramdisk writeback respects barriers
> > > and ordering rules ?
> > 
> > I was alluding to to e2fsck's amazing repair ability, not ext3's journal.
> 
> Oh you mean "pray hard". e2fsck works well with typical disk style
> failures, it is not robust against random chunks vanishing. I know this
> as I've worked on and debugged a case where a raid card rebooted silently
> and threw out the write back cache.

So then you know that people already rely on batteries in critical storage
applications.  So I do not understand why all the FUD from you.

Particularly about Ext2/Ext3, which does recover well from random damage.
My experience.

> > Your comment re fs chunk size reveals that I have failed to
> > communicate the most basic principle of the ramback design: the
> > backing store is not expected to represent a consistent filesystem
> 
> No I get that. You've ignored the fact I'm suggesting that design choice
> is dumb.

You seem to be calling Linux unreliable.

Daniel
