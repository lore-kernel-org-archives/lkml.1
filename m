Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYELDXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYELDXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 23:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbYELDWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 23:22:54 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49435 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753608AbYELDWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 23:22:54 -0400
Date: Sun, 11 May 2008 22:03:01 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Possible regression?  2.6.26-rc1: X61s failure after
	suspend/resume
Message-ID: <20080512020301.GA8390@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
	Jesse Barnes <jbarnes@virtuousgeek.org>
References: <E1JuCBA-0002NZ-4E@closure.thunk.org> <200805082352.04352.rjw@sisk.pl> <20080509024426.GB8871@mit.edu> <20080509094941.GA19617@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509094941.GA19617@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 11:49:41AM +0200, Ingo Molnar wrote:
> 
> on the off chance that this might be related: could you try to boot with 
> nopat?

I did some more testing, and on my X61s laptop, using a somewhat more
recent snapshot (v2.6.26-rc1-434-g9662369 from Linus's tree Sunday
morning), I was able to reproduce the failure after a suspend/resume
without nopat, but after adding nopat, the problem seems to have gone
away.

I'll do some more testing, but it looks hopeful that this might be
another manisfestation of

http://bugzilla.kernel.org/show_bug.cgi?id=10620

and booting with nopat works around the problem.

							- Ted
