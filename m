Return-Path: <linux-kernel-owner+w=401wt.eu-S1762024AbYDVPZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762024AbYDVPZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762993AbYDVPZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:25:29 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1928 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933950AbYDVPZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:25:27 -0400
Date: Tue, 22 Apr 2008 16:25:09 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, bunk@kernel.org,
       astarikovskiy@suse.de, tglx@linutronix.de,
       James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080422152509.GE26446@shadowen.org>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <480C8EC8.3080705@zytor.com> <20080422062927.bb360a36.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422062927.bb360a36.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 06:29:27AM -0700, Andrew Morton wrote:
> > On Mon, 21 Apr 2008 08:55:36 -0400 "H. Peter Anvin" <hpa@zytor.com> wrote:
> >
> > If there are no VISWS' left, we should just unload the code.
> 
> yup, it's a desirable objective.
> 
> I have a suspicion that there are no NUMAQs left either.  Andy, would it be
> missed?

Cirtainly these boxes are getting near end-of-life.  I am not sure how
many are out there beyond our the ones we have in the lab.  We do
maintain regular testing on them, even reporting them to TKO.

The main reason we bother keeping them working is that they have a large
numa ratio and tend to show up issues with other things, like the numa
scheduler issues when we got that latest re-write.

I has always been a shame that support wasn't included in generic, and
as a result we have ended up with this three way split "generic, voyager,
and numaq".  It made sense at the time for developers, but never did for
those down the food chain; particularly for distros.

-apw
