Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbYFXV4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbYFXV4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbYFXV4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:56:13 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38985 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587AbYFXV4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:56:03 -0400
Date: Wed, 25 Jun 2008 00:54:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com
Subject: Re: [patch 2.6.26-rc7] <linux/bcd.h> space reduction
Message-ID: <20080624215400.GA18252@cs181140183.pp.htv.fi>
References: <200806221954.37088.david-b@pacbell.net> <20080623065034.GG20122@cs181140183.pp.htv.fi> <200806230015.49973.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200806230015.49973.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 12:15:49AM -0700, David Brownell wrote:
> On Sunday 22 June 2008, Adrian Bunk wrote:
> > On Sun, Jun 22, 2008 at 07:54:36PM -0700, David Brownell wrote:
> > > This updates <linux/bcd.h> to define the key routines as static
> > > constant functions, which the macros will then call.
> > > 
> > > 	... Typical per-driver savings top 200 bytes. ...
> > 
> > The patch breaks the compilation:
> 
> Needs to #include <linux/types.h> then; "u8" isn't always known.
> Or maybe just spell it out "unsigned char".
> 
> 
> >	...
> > 
> > Additionally, I'd suggest to make them out-of-line functions 
> > instead of shipping multiple copies in different object files.
> 
> That was one of the options.  I thought I'd start with something
> simpler, and see what folk thought.
> 
> Where would that be ... lib/bcd.c, always linked?

Sounds good.

> And if it goes
> that way I'd prefer bcd2bin() and bin2bcd(), not these names.  A
> small impetus to have LESS SOURCE CODE SHOUTING AT ME.

Sounds good, but start with SHOUTING COMPATIBILITY #DEFINES FOR THE 
EXISTING USERS and either clean them up later or let me do the cleanup.

> - Dave

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

