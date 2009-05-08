Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbZEHJLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbZEHJLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758192AbZEHJLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:11:25 -0400
Received: from mail46.e.nsc.no ([193.213.115.46]:39362 "EHLO mail46.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758274AbZEHJLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:11:24 -0400
Date: Fri, 8 May 2009 11:10:52 +0200
From: Henrik Austad <henrik@austad.us>
To: GeunSik Lim <leemgs1@gmail.com>
Cc: finarfin@dreamos.org, linux-kernel@vger.kernel.org
Subject: Re: SCHED_EDF infos
Message-ID: <20090508091052.GA10429@januz.myftp.org>
References: <164c92d827cbee86ba2c5621716309e6@localhost> <200904300939.31754.henrik@austad.us> <49b7c2350905071935kbd2aa22v9d39cf41c537c24b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49b7c2350905071935kbd2aa22v9d39cf41c537c24b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 11:35:58AM +0900, GeunSik Lim wrote:
> Hi Henlik,

Hi Lim,


First off, to all of you, sorry for my last, very poorly formatted email. I 
have now tranceded into the realms of mutt.

> [..]
> I think so.
> How can we approach  EDF implementation like Pfair as a generic solution
> for Multicore in Linux?

I am working on an implementation now, and I hope to be able to release a 
prototype by the end of next week. I think we can continue the discussion 
then based on that.

> > I'm working on SCHED_PFAIR :-) Which is a multicore, ratebased deadline 
> > driven global scheduling policy where I use the PD^2 rules to solve 
> > tie-breaks. In theory, it can reach 100% utilization on all cores 
> > without missing deadlines (but in practice you will only get close to 
> > 100% as it is not perfect).

> > [..]
> > I'd suggest getting the scheduler running first, then look at those
> > problems later. If you spend all your time trying to learn the 
> > scheduler and design in every little feature you need, you'll never 
> > finish in time.

> In fact, I also  don't have perfect know how to solve PI in Multicore.
> [...]
> > deadline inversion will be a problem, in fact, whatever you chooose to 
> > be the 'key' for picking tasks (priority, niceness, deadlines, wind 
> > direction, <whatever>), you can pretty much take that and add a 
> > -inversion after it. :)

No, PI is going to be deadly no matter what you do.

Henrik
