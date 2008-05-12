Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbYELLf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbYELLf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbYELLfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:35:19 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45201 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753015AbYELLfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:35:17 -0400
Date: Mon, 12 May 2008 07:35:02 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Possible regression?  2.6.26-rc1: X61s failure after
	suspend/resume
Message-ID: <20080512113501.GA7687@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
	Jesse Barnes <jbarnes@virtuousgeek.org>
References: <E1JuCBA-0002NZ-4E@closure.thunk.org> <200805082352.04352.rjw@sisk.pl> <20080509024426.GB8871@mit.edu> <20080509094941.GA19617@elte.hu> <20080512020301.GA8390@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512020301.GA8390@mit.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 10:03:01PM -0400, Theodore Tso wrote:
> On Fri, May 09, 2008 at 11:49:41AM +0200, Ingo Molnar wrote:
> > 
> > on the off chance that this might be related: could you try to boot with 
> > nopat?
> 
> I did some more testing, and on my X61s laptop, using a somewhat more
> recent snapshot (v2.6.26-rc1-434-g9662369 from Linus's tree Sunday
> morning), I was able to reproduce the failure after a suspend/resume
> without nopat, but after adding nopat, the problem seems to have gone
> away.

Actually, it looks like I spoke too quickly.  I'll do some more
testing, but it looks like either (a) I got lucky, or (b) it's a lot
harder to trigger with nopat.  In any case, after getting home and
docking my workstation, I started a kernel build, and approximately 15
minutes later, the X server hung with the same symptoms as before.

	       	     	    	      	  - Ted
