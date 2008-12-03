Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbYLCEhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbYLCEhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYLCEhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:37:22 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:48609 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751148AbYLCEhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:37:21 -0500
Date: Tue, 2 Dec 2008 23:37:12 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jonathan Bastien-Filiatrault <joe@x2a.org>
Cc: Andres Freund <andres@anarazel.de>, Andreas Dilger <adilger@sun.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: EXT4 ENOSPC Bug
Message-ID: <20081203043712.GJ20858@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jonathan Bastien-Filiatrault <joe@x2a.org>,
	Andres Freund <andres@anarazel.de>,
	Andreas Dilger <adilger@sun.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
References: <200811291418.24672.andres@anarazel.de> <200812021559.05103.andres@anarazel.de> <20081202164709.GC18162@mit.edu> <200812021847.35771.andres@anarazel.de> <20081202203315.GA20858@mit.edu> <4935D4C0.7050601@x2a.org> <4935D58B.4020002@x2a.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4935D58B.4020002@x2a.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 07:40:43PM -0500, Jonathan Bastien-Filiatrault wrote:
> Jonathan Bastien-Filiatrault wrote:
> > Theodore Tso wrote:
> > 
> >> Hmm...  really?  Was the error message ENOSPC, or something else?
> >>
> > I can confirm I get a ENOSPC on open/creat. Here is the relevant output
> > from strace touch test:
> > 
> (Sorry for replying to myself)
> 
> This happened while compiling a kernel with ccache enabled (with a
> relatively low hit rate for this specific build). Vuze was also opened,
> but with no active download.

Hmm... I build with ccache all the time.  I normally don't run a
bittorrent client, though.  What kernel version are you using?

Any chance you can apply the patch which I sent earlier in this
thread, trigger the debugging ioctl when it happens again?

Thanks,

		    	      	    	    - Ted
