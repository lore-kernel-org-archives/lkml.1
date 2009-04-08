Return-Path: <linux-kernel-owner+w=401wt.eu-S1765485AbZDHPHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765485AbZDHPHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932144AbZDHPHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:07:32 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:41964 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763472AbZDHPHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:07:31 -0400
Date: Wed, 8 Apr 2009 17:06:57 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>, Bert Wesarg <bert.wesarg@googlemail.com>,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 54/56] x86: Remove void casts
In-Reply-To: <49DCBBDF.4040603@fastmail.fm>
Message-ID: <Pine.LNX.4.64.0904081705390.9554@pc-004.diku.dk>
References: <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm>
 <36ca99e90904080518qf81b483h6ed2bc9752ee0d1e@mail.gmail.com>
 <49DCAE97.8040602@fastmail.fm> <20090408140637.GC12931@elte.hu>
 <49DCB140.7000603@fastmail.fm> <20090408144055.GH12931@elte.hu>
 <49DCB8C5.4090108@fastmail.fm> <20090408144842.GK12931@elte.hu>
 <49DCBA61.8060507@fastmail.fm> <20090408145715.GO12931@elte.hu>
 <49DCBBDF.4040603@fastmail.fm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009, Jack Stone wrote:

> Ingo Molnar wrote:
> > * Jack Stone <jwjstone@fastmail.fm> wrote:
> >
> >   
> >> Ingo Molnar wrote:
> >>     
> >>> No, i mean, this approach should be changed, and i dont think any 
> >>> type cast change should go via any trivial tree. It's easy to mess 
> >>> it up. Please submit them to the maintainer trees
> >>>       
> >> Ok. I'll try and find appropriate CCs. I'm going out shortly so it 
> >> might take me a while.
> >>     
> >
> > Since you do many such patches it might make sense to script up a 
> > "who maintains what" kind of script - and share that script with 
> > lkml.
> >
> > I have this silly little script:
> >
> >   git log $@ | grep Signed-off-by: |
> >    cut -d: -f2 | cut -d\< -f1 |
> >     sort | uniq -c | sort -n
> >
> > To find out any recent parties that touches a particular file. But 
> > it would be nice to somehow automate the pickup of mailing-list 
> > addresses from MAINTAINERS for example. We've literally got hundreds 
> > of email lists there.
> >
> > It is not trivial to do though :-)
> >   
> It would be useful. The main problem is working out what files belong to
> what MAINTAINERS entries.
> 
> I'll see what I can cook up.

This can be helpful: http://lwn.net/Articles/284469/

It's a bit out of date, though, because git-blame seems to have 
disappeared as a command.

julia
