Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYBRPfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYBRPfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYBRPfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:35:20 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49023 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752271AbYBRPfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:35:19 -0500
Date: Mon, 18 Feb 2008 10:35:01 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
Message-ID: <20080218153501.GE25098@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	LKML <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu> <47B99E0C.8020706@wpkg.org> <20080218151632.GD25098@mit.edu> <20080218155725.GB26622@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218155725.GB26622@one.firstfloor.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 04:57:25PM +0100, Andi Kleen wrote:
> > Use cp
> > or a tar pipeline to move the files.
> 
> Are you sure cp handles hardlinks correctly? I know tar does,
> but I have my doubts about cp.

I *think* GNU cp does the right thing with --preserve=links.  I'm not
100% sure, though --- like you, probably, I always use tar for moving
or copying directory hierarchies.

  	     	     	       	       - Ted
