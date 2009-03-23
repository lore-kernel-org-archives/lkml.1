Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbZCWKxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbZCWKxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZCWKxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:53:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:52779 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbZCWKxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:53:30 -0400
Subject: Re: [git-pull -tip] x86: cleanup patches 20090322
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Hannes Eder <hannes@hanneseder.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <154e089b0903230335q1fbdcc4biea140738b01e7a36@mail.gmail.com>
References: <1237755176.5417.16.camel@ht.satnam>
	 <200903231845.05394.rusty@rustcorp.com.au>
	 <1237801506.2485.7.camel@ht.satnam>
	 <154e089b0903230335q1fbdcc4biea140738b01e7a36@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 16:22:40 +0530
Message-Id: <1237805560.2630.16.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-23 at 11:35 +0100, Hannes Eder wrote:
> On Mon, Mar 23, 2009 at 10:45 AM, Jaswinder Singh Rajput
> <jaswinder@kernel.org> wrote:
> > On Mon, 2009-03-23 at 18:45 +1030, Rusty Russell wrote:
> >> On Monday 23 March 2009 07:22:56 Jaswinder Singh Rajput wrote:
> >> >       x86: e820.h fix various signedness issues in setup.c and e820.c
> >>
> >> Wouldn't fixing the users be better than changing the header?  Esp. since
> >> it could well now cause similar warnings in userspace programs.
> >>
> >> >  struct e820map {
> >> > -   __u32 nr_map;
> >> > +   __s32 nr_map;
> >> >     struct e820entry map[E820_X_MAX];
> >> >  };
> >>
> >> This number can't be negative!
> >>
> >
> > Is this OK, or should I go more further:
> 
> since sanitize_e820_map does only modify its third argument on
> success, and leaves it untouched on error, the temporary variable
> could be eliminated in some places.

OK, this is different issue so I will send this in separate patch.

Thanks,
--
JSR

