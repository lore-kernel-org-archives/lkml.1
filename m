Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbYHSQ67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbYHSQ67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbYHSQ6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:58:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53445 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbYHSQ6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:58:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #11330] int3: 0000 in tsc_read_refs when using powernow_k7
Date: Tue, 19 Aug 2008 19:02:10 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alok Kataria <akataria@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel Hecht <dhecht@vmware.com>, Mikko Vinni <mmvinni@yahoo.com>,
       the arch/x86 maintainers <x86@kernel.org>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <20080818183328.GB22989@elte.hu> <20080819002232.GF9914@elte.hu>
In-Reply-To: <20080819002232.GF9914@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808191902.11282.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 19 of August 2008, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > There is this fix 
> > > 
> > > commit d554d9a4295dd0595d12eeccbc55d1f495b15176
> > > Author: Marcin Slusarz <marcin.slusarz@gmail.com>
> > > Date:   Mon Aug 11 00:07:44 2008 +0200
> > > 
> > >     x86, tsc: fix section mismatch warning
> > > 
> > > which is in x86/tip-master which fixes this issue. 
> > > I don't see the fix in the mainline tree yet. 
> > > 
> > > Maybe Ingo, has it queued, for upstream ?
> > > Ingo, other than a section mismatch warning it also fixes a real bug.
> > 
> > yeah, hpa queued it up into x86/urgent as well earlier today, it will go 
> > out with the next pull request.
> 
> FYI, commit d554d9a4295d is upstream now, and will be part of -rc4.

Thanks, I closed the bug.

Rafael
