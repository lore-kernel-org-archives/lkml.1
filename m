Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYAQTpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYAQTpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYAQTo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:44:57 -0500
Received: from hu-out-0506.google.com ([72.14.214.230]:65106 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbYAQTo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:44:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=AeKcfhPKPmcdwp8NxRxxRJD0meHmVsMMJ6yEqHPNuqtkJ47YSJDJXXDr7m8WsSG2DCYQJrYYVwczzgqMGNABcZOgvLxnmI2m4ZaQEK2SvOUdOG/bWnh3RFjetKlbOnjmKC7oTU0zF5hmbvY4AVYPgLo7YH1TguTlOO/njfrBB+M=
Date: Thu, 17 Jan 2008 20:47:28 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dave Young <hidave.darkstar@gmail.com>, Greg KH <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, david-b@pacbell.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080117194728.GA2598@ami.dom.local>
References: <a8e1da0801161718w573ac941jc83011e63c47ecf@mail.gmail.com> <Pine.LNX.4.44L0.0801171014030.4378-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0801171014030.4378-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 10:16:30AM -0500, Alan Stern wrote:
> On Thu, 17 Jan 2008, Dave Young wrote:
> 
> > > Your meaning isn't clear.  Do you mean that your patch doesn't generate
> > > any lockdep warnings at all?  Or do you mean that it generates a single
> > > lockdep warning at boot time and then no more warnings afterward?
> > 
> > I means the latter one.
> 
> That's very bad.
> 
> For each type of violation, lockdep only gives one error message.  So
> the fact that you get one message at boot time and then no more doesn't
> mean the code is almost right -- it probably means the code has lots of
> errors and you're seeing only the first one.

I hope it's better than this: lockdep really stops checking after first
warning, but I've understood from David's description that after fixing
this one place lockdep seems to be pleased.

On the other hand, according to Greg the code is OK, so if there are any
such warnings they simply have to be false! (...Unless you trust lockdep
more?!)

Regards,
Jarek P.
