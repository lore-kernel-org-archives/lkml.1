Return-Path: <linux-kernel-owner+w=401wt.eu-S1761806AbYHESiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761806AbYHESiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756900AbYHEShh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:37:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:23126 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbYHEShg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:37:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Biw2b+pj7aMwpwy9cSXMUwHu6CJRVJz1+eN1bGPa3orm0uDKTPcc4gONlZsy7kFdY2
         OprMHsV5Z5SmSGHh+yHd+fGLdu7hXOqTUsxNSj7wNcv/EXfs1slxAoULuSCKa2Vxl7eO
         dCqxWctiMfhUqPEt40xgc/UuJejFa1b0ylxr0=
Date: Tue, 5 Aug 2008 20:36:43 +0200
From: Bernhard Fischer <rep.dot.nop@gmail.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Adrian Bunk <bunk@kernel.org>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       bcrl@kvack.org, linux-aio@kvack.org, akpm@linux-foundation.org
Subject: Re: [patch 1/4] Configure out AIO support
Message-ID: <20080805183643.GJ9208@mx.loc>
References: <20080731092703.661994657@free-electrons.com> <20080731093220.690886851@free-electrons.com> <20080731100929.GA9206@mx.loc> <20080731101219.GC4221@cs181140183.pp.htv.fi> <20080731224222.GB9208@mx.loc> <20080805181536.GH22895@cs181140183.pp.htv.fi> <20080805182607.GA28513@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805182607.GA28513@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 07:26:07PM +0100, Jamie Lokier wrote:

>> > >The userspace headers are independent of any kernel configuration
>> > >(except for the architecture).
>> > 
>> > I beg to disagree:
>> > internals as exposed by e.g. aio_abi.h are impl dependent. Noone except
>> > the impl and it's users are interrested in it.
>> >...
>> 
>> That's utter bullshit.
>> 
>> The contents of aio_abi.h is a kernel<->userspace ABI that mustn't ever 
>> change. [1]
>
>Case in point:
>
>I want to be able to compile an application for embedded Linux which
>*can use* Linux-AIO, but can also run on a kernel which has Linux-AIO
>removed by this patch.
>
>I still want to compile the application with that capability, in case
>it's run on another kernel with it enabled.
>
>I shouldn't have to have a separate, special kernel with all options
>enabled, just to compile applications that run on multiple kernels and
>use run-time features when available.
>
>Just like all the other kernel<->userspace interfaces, the header
>files (including their presence) shouldn't depend on kernel
>configuration at all.

alright, makes perfect sense. I must have been playing too much with
libc recently, i guess.

thanks,
