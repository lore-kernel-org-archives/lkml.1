Return-Path: <linux-kernel-owner+w=401wt.eu-S1759091AbXKAVyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbXKAVyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 17:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbXKAVy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:54:27 -0400
Received: from styx.suse.cz ([82.119.242.94]:43308 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757993AbXKAVy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:54:26 -0400
Date: Thu, 1 Nov 2007 22:54:24 +0100
From: Jan Kara <jack@suse.cz>
To: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.23: Filesystem capabilities 0.17
Message-ID: <20071101215424.GA27788@duck.suse.cz>
References: <871wbhc0zj.fsf@olafdietsche.de> <20071031170853.GD28809@atrey.karlin.mff.cuni.cz> <87tzo5925v.fsf@olafdietsche.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tzo5925v.fsf@olafdietsche.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-11-07 20:49:32, Olaf Dietsche wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> This patch implements filesystem capabilities. It allows to
> >> run privileged executables without the need for suid root.
> >   Hmm, is there some "design document" so that one does not have to poke
> > through the code and find out what it's actually trying to do?
> 
> What do you mean with "trying to do"? I thought this is obvious, it
> provides executables with filesystem capabilities.
  Well, yes, that was obvious but I rather meant "how is it doing it?".
So where does it store these bits and such.

> > Also why don't you use extended attributes or store them inside the
> > executable like Pavel did (you link it from your web page).
> 
> The links from my web page are there to show alternatives, nothing
> else. When I started in 2002, xattr where pretty new or nonexistant.
  OK, I see. I'm not sure it's going to make it when we already have an
implementation of the functionality in kernel as Serge mentioned.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
