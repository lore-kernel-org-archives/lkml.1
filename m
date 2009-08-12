Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbZHLFB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbZHLFB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 01:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZHLFBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 01:01:55 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:44001 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbZHLFBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 01:01:54 -0400
Date: Wed, 12 Aug 2009 07:01:52 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Nicolas Palix <npalix@diku.dk>
Subject: Re: Typedef removal tool
In-Reply-To: <43e72e890908111418m47910085k2d0016e2add8914f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0908120659001.32131@ask.diku.dk>
References: <43e72e890908111418m47910085k2d0016e2add8914f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009, Luis R. Rodriguez wrote:

> Anyone know if there is a typedef removal tool? When porting drivers
> this needs to be done quite often.
> 
> FWIW I've started porting some driver and have come across some tools,
> or written my own scripts, which have helped. Using spatch to port a
> driver was such a tool I explored. I think I'll try to put together
> some info on the driver project wiki for this. typdef removal tool
> would still be neat.

Nicolas Palix (in CC) did a bit of work on this recently using Coccinelle, 
but the problem is that simply removing the typedef is not enough, one has 
to come up with a name that is within the spirit of the names used in 
Linux, or perhaps recognize that the structure in question already exists 
in a more general form in the kernel an thus the declaration should be 
removed completely.

Someone else made a dedicated tool using a dictionary of the old and new 
names that at least partially addresses these problems.  Nicolas knows who 
that person is.

julia
