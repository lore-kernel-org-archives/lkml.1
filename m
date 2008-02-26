Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYBZM3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYBZM3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 07:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYBZM24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 07:28:56 -0500
Received: from relay2.sgi.com ([192.48.171.30]:57727 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751054AbYBZM2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 07:28:55 -0500
Date: Tue, 26 Feb 2008 06:28:50 -0600
From: Robin Holt <holt@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Gleb Natapov <glebn@voltaire.com>, Robin Holt <holt@sgi.com>,
       steiner@sgi.com, Andrea Arcangeli <andrea@qumranet.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Izik Eidus <izike@qumranet.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       daniel.blueman@quadrics.com, general@lists.openfabrics.org,
       akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>
Subject: Re: [ofa-general] Re: [patch 5/6] mmu_notifier: Support for
	drivers with revers maps (f.e. for XPmem)
Message-ID: <20080226122850.GP11391@sgi.com>
References: <20080215064859.384203497@sgi.com> <200802261711.33213.nickpiggin@yahoo.com.au> <20080226072137.GD26611@minantech.com> <200802261952.42567.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802261952.42567.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 07:52:41PM +1100, Nick Piggin wrote:
> On Tuesday 26 February 2008 18:21, Gleb Natapov wrote:
> > On Tue, Feb 26, 2008 at 05:11:32PM +1100, Nick Piggin wrote:
> > > > You are missing one point here.  The MPI specifications that have
> > > > been out there for decades do not require the process use a library
> > > > for allocating the buffer.  I realize that is a horrible shortcoming,
> > > > but that is the world we live in.  Even if we could change that spec,
> > >
> > > Can you change the spec?
> >
> > Not really. It will break all existing codes.
> 
> I meant as in eg. submit changes to MPI-3
> 
> 
> > MPI-2 provides a call for 
> > memory allocation (and it's beneficial to use this call for some
> > interconnects), but many (most?) applications are still written for MPI-1
> > and those that are written for MPI-2 mostly uses the old habit of
> > allocating memory by malloc(), or even use stack or BSS memory for
> > communication buffer purposes.
> 
> OK, so MPI-2 already has some way to do that... I'm not saying that we
> can now completely dismiss the idea of using notifiers for this, but it
> is just a good data point to know.

It is in MPI-2, but MPI-2 does not prohibit communication from regions
not allocated by the MPI call.

Thanks,
Robin
