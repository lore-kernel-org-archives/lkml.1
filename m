Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbYBRPVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbYBRPVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYBRPVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:21:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52237 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbYBRPVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:21:24 -0500
Date: Mon, 18 Feb 2008 16:57:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Theodore Tso <tytso@mit.edu>, Tomasz Chmielewski <mangoo@wpkg.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
Message-ID: <20080218155725.GB26622@one.firstfloor.org>
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu> <47B99E0C.8020706@wpkg.org> <20080218151632.GD25098@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218151632.GD25098@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 10:16:32AM -0500, Theodore Tso wrote:
> On Mon, Feb 18, 2008 at 04:02:36PM +0100, Tomasz Chmielewski wrote:
> > I tried to copy that filesystem once (when it was much smaller) with "rsync 
> > -a -H", but after 3 days, rsync was still building an index and didn't copy 
> > any file.
> 
> If you're going to copy the whole filesystem don't use rsync! 

Yes, I managed to kill systems (drive them really badly into oom and
get very long swap storms) with rsync -H in the past too. Something is very 
wrong with the rsync implementation of this.

> Use cp
> or a tar pipeline to move the files.

Are you sure cp handles hardlinks correctly? I know tar does,
but I have my doubts about cp.

-Andi
