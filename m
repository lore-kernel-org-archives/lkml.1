Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbYBTQ5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbYBTQ5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbYBTQ5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:57:42 -0500
Received: from smtp118.sbc.mail.re3.yahoo.com ([66.196.96.91]:32615 "HELO
	smtp118.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754668AbYBTQ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:57:41 -0500
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 20 Feb 2008 10:55:07 -0600
From: serge@hallyn.com
To: Nick Andrew <nick@nick-andrew.net>
Cc: Paul Menage <menage@google.com>, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Improve init/Kconfig help descriptions [PATCH 6/9]
Message-ID: <20080220165507.GB14550@vino.hallyn.com>
References: <20080219140609.GA26619@tull.net> <20080219151214.GD27352@tull.net> <6599ad830802191804y171282c1m646bdb47b83e2bc2@mail.gmail.com> <20080220025431.GA10766@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220025431.GA10766@tull.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nick Andrew (nick@nick-andrew.net):
> On Tue, Feb 19, 2008 at 06:04:57PM -0800, Paul Menage wrote:
> > On Feb 19, 2008 7:12 AM, Nick Andrew <nick@nick-andrew.net> wrote:
> > >  config CGROUPS
> > > [...]
> > > +         When enabled, a new filesystem type "cgroup" is available
> > > +         and can be mounted to control cpusets.
> > How about:
> > ... cpusets and other resource/behaviour controllers.
> 
> Ok I added that. This is what I have now:
> 
> 
> config CGROUPS
>         bool "Control Group support"
>         help
> 	  Control Groups enables processes to be tracked and grouped
> 	  into "cgroups". This enables you, for example, to associate

Maybe 
	  Control Groups enable processes to be grouped into "cgroups"
	  to facilitate tracking and resource management.  For example
	  a cgroup can tie a set of processes to a set of cpus using
	  "cpusets".

> 	  When enabled, a new filesystem type "cgroup" is available
> 	  and can be mounted to control cpusets and other
> 	  resource/behaviour controllers.
> 
> 	  See <file:Documentation/cgroups.txt> for more information.
> 
> 	  If unsure, say N.
> 
> 
> I don't think that description is as clear as it could be. From
> the non-kernel-developer point of view, that is. I'll read
> Documentation/cgroups.txt more thoroughly and see if I can come
> up with a better description.
> 
> Re "other resource/behaviour controllers", what in particular?
> I take it that our current controllers are cpusets, scheduler,
> CPU accounting and Resource counters?
> 
> Nick.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
