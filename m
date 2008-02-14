Return-Path: <linux-kernel-owner+w=401wt.eu-S1765642AbYBNJuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765642AbYBNJuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 04:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYBNJtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 04:49:52 -0500
Received: from styx.suse.cz ([82.119.242.94]:54141 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753368AbYBNJtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 04:49:51 -0500
Date: Thu, 14 Feb 2008 10:49:49 +0100
From: Jan Kara <jack@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: udf regression: broken directory handling
Message-ID: <20080214094948.GA20299@duck.suse.cz>
References: <20080210104754.GH6737@joi> <20080212113916.GA13425@duck.suse.cz> <20080212182638.GA8334@joi> <200802132336.05560.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802132336.05560.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 13-02-08 23:36:05, Rafael J. Wysocki wrote:
> On Tuesday, 12 of February 2008, Marcin Slusarz wrote:
> > On Tue, Feb 12, 2008 at 12:39:17PM +0100, Jan Kara wrote:
> > > On Mon 11-02-08 20:13:20, Marcin Slusarz wrote:
> > > > On Mon, Feb 11, 2008 at 12:09:10PM +0100, Jan Kara wrote:
> > > > >   Hi,
> > > > > 
> > > > > On Sun 10-02-08 11:48:17, Marcin Slusarz wrote:
> > > > > > Current mainline has a problem with reading file list.
> > > > > > Simple ls prints only 2 out of 8 files on my testing DVD.
> > > > > > Reverting your patch "udf: cleanup directory offset handling"
> > > > > > (af793295bf9ee92660f5e77d337b0493cea3f9b9) fixes the problem.
> > > > >   Thanks for testing! Do you have a way to create such UDF filesystem? For
> > > > > the filesystems I've created it seems to work just fine...
> > > > 
> > > > with patch applied:
> > >   <snip testing>
> > > 
> > >   Argh, I've submitted an old version of the patch missing changes in
> > > dir.c. Below is the missing hunk. Does UDF work for you with it?
> > Yes.
> 
> Has the issue been fixed in the mainline?
  Andrew has the fix in his queue so it'll get to mainline soon.

										Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
