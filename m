Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZKTVU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZKTVU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbZKTVU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:20:57 -0500
Received: from kroah.org ([198.145.64.141]:50541 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbZKTVUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:20:55 -0500
Date: Fri, 20 Nov 2009 12:15:39 -0800
From: Greg KH <greg@kroah.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       Luis.Rodriguez@atheros.com
Subject: Re: [PATCH v2] staging/otus: trivial, fix sparse warnig.
Message-ID: <20091120201539.GA24523@kroah.com>
References: <1256861066-21954-1-git-send-email-tfransosi@gmail.com>
 <20091106224728.GA32205@kroah.com>
 <a4c8a6d00911061547x3d502de5i8a459385e1a5a9ff@mail.gmail.com>
 <20091107000749.GA26070@kroah.com>
 <a4c8a6d00911061723v6017ad7bqf96ba7c905922a45@mail.gmail.com>
 <a4c8a6d00911061745s4508d997v684683a1dbad821d@mail.gmail.com>
 <20091119193447.GA29091@kroah.com>
 <a4c8a6d00911201118n7607b0f8nf56f7af1e071afb6@mail.gmail.com>
 <20091120192250.GA16773@kroah.com>
 <a4c8a6d00911201209p2da69bb5s50b6d098107842db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4c8a6d00911201209p2da69bb5s50b6d098107842db@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 06:09:09PM -0200, Thiago Farina wrote:
> On Fri, Nov 20, 2009 at 5:22 PM, Greg KH <greg@kroah.com> wrote:
> > On Fri, Nov 20, 2009 at 05:18:09PM -0200, Thiago Farina wrote:
> >> Hi Greg,
> >>
> >> On Thu, Nov 19, 2009 at 5:34 PM, Greg KH <greg@kroah.com> wrote:
> >> > On Fri, Nov 06, 2009 at 11:45:05PM -0200, Thiago Farina wrote:
> >> >> *apdbg.c: use NULL pointer instead of 0 integer.
> >> >>
> >> >> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> >> >
> >> > Still doesn't apply, I don't know what you are doing wrong here :(
> >> >
> >> > odd.
> >>
> >> How are you applying it?
> >
> > 'patch -p1 < your_email'
> 
> Are you getting something like: "Hmm... Ignoring the trailing garbage." ?
> 
> The output for me was this:
> ...
> Patching file drivers/staging/otus/apdbg.c using Plan A...
> Hunk #1 succeeded at 109.
> Hunk #2 succeeded at 123.
> Hmm...  Ignoring the trailing garbage.
> done

Are you appling this to the linux-next tree?  Or Linus's tree?  I just
get a failure against linux-next.

thanks,

greg k-h
