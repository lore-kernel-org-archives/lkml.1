Return-Path: <linux-kernel-owner+w=401wt.eu-S1758999AbYABNfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbYABNfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbYABNfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:35:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41481 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbYABNfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:35:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc6-git7: Reported regressions from 2.6.23
Date: Wed, 2 Jan 2008 14:37:38 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Zhenyu Wang <zhenyu.z.wang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200801012202.57851.rjw@sisk.pl> <200801021412.07313.rjw@sisk.pl> <20080102132415.GB13237@elte.hu>
In-Reply-To: <20080102132415.GB13237@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801021437.38993.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of January 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Wednesday, 2 of January 2008, Zhenyu Wang wrote:
> > > On 2008.01.01 22:02:57 +0000, Rafael J. Wysocki wrote:
> > > > Subject		: linux-2.6.24-rcX regression / xserver-xorg-video-intel / Q35
> > > > Submitter	: Harald Welte <laforge@gnumonks.org>
> > > > Date		: 2007-12-22 04:37
> > > > References	: http://lkml.org/lkml/2007/12/21/269
> > > > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9618
> > > > Handled-By	: Zhenyu Wang <zhen78@gmail.com>
> > > > Patch		: 
> > > 
> > > This is resolved by turning on CONFIG_DMAR_GFX_WA.
> > 
> > OK, I have removed it from the list.
> 
> because it's default-enabled, and someone would have to consciously 
> disable it to intentionally trigger DMA bugs in drivers, right?

Yes.  Plus there's a statement at
http://bugzilla.kernel.org/show_bug.cgi?id=9618#c2
that clarifies it further.

Rafael
