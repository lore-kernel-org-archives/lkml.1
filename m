Return-Path: <linux-kernel-owner+w=401wt.eu-S932156AbYEHTGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbYEHTGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbYEHTF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:05:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:38093 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546AbYEHTFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:05:55 -0400
Date: Thu, 8 May 2008 21:05:54 +0200
From: Jan Kara <jack@suse.cz>
To: Yan Seiner <yan@seiner.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kenrel oops
Message-ID: <20080508190554.GB4090@atrey.karlin.mff.cuni.cz>
References: <4814DBFA.2070901@seiner.com> <20080508185221.GA4090@atrey.karlin.mff.cuni.cz> <50279.199.79.32.17.1210273206.squirrel@www.datavault.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50279.199.79.32.17.1210273206.squirrel@www.datavault.us>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Jan Kara
> >> I just had this kernel oops.  Approximately 5 mintes later, the machine
> >> hard-locked.  Can anyone give me some guidance on where to look?
> >   Any chance of reproducing this without the NVidia module? It looks
> > like filp->f_op->flush contained an invalid pointer (although
> > ffff81007e3d1300 doesn't look completely insane but more like a pointer
> > to data than to a function). Weren't you playing with rmmod before this
> > happened?
> 
> I was playing with Xephyr on top of X, so it's possible that the script I
> was using tried to load the opensource nv module on top of the nvidia
> module and/or that there was repeated insmod/rmmod of nvidia and nv before
> this happened.
  I mean more like removing some filesystem modules or so which doesn't
seem to be the case.

> I've not been able to reproduce this since.
  OK. So far I have no clue what could have caused this (besides some
weird corruption with nvidia module) so I'll wait if someone comes with
a similar report...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
