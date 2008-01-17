Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbYAQVQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbYAQVQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757055AbYAQVQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:16:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:53539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbYAQVQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:16:13 -0500
Date: Thu, 17 Jan 2008 13:11:01 -0800
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jarek Poplawski <jarkao2@gmail.com>,
       Dave Young <hidave.darkstar@gmail.com>, stefanr@s5r6.in-berlin.de,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080117211101.GA11853@suse.de>
References: <20080117194728.GA2598@ami.dom.local> <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 02:57:36PM -0500, Alan Stern wrote:
> On Thu, 17 Jan 2008, Jarek Poplawski wrote:
> > On the other hand, according to Greg the code is OK, so if there are any
> > such warnings they simply have to be false! (...Unless you trust lockdep
> > more?!)
> 
> It's not a matter of trust or of false warnings.  People shouldn't 
> tolerate any lockdep warnings at all; otherwise they will start to 
> ignore the valid ones.
> 
> Alan Stern
> 
> P.S.: Just because Greg says the code is okay doesn't mean it will 
> please lockdep -- it doesn't even mean the code really is okay!  I've 
> known Greg to make an occasional mistake.

I've known Greg to make lots of mistakes :)

I don't remember ever saying that the "code is correct with the lockdep
warnings", I think I said, "Make sure there are no lockdep warnings with
any conversion you do."

thanks,

greg k-h
