Return-Path: <linux-kernel-owner+w=401wt.eu-S1762824AbYBTCzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762824AbYBTCzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 21:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763720AbYBTCzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 21:55:05 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:41489 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1763714AbYBTCzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 21:55:03 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Wed, 20 Feb 2008 13:54:31 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Paul Menage <menage@google.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Improve init/Kconfig help descriptions [PATCH 6/9]
Message-ID: <20080220025431.GA10766@tull.net>
References: <20080219140609.GA26619@tull.net> <20080219151214.GD27352@tull.net> <6599ad830802191804y171282c1m646bdb47b83e2bc2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830802191804y171282c1m646bdb47b83e2bc2@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 06:04:57PM -0800, Paul Menage wrote:
> On Feb 19, 2008 7:12 AM, Nick Andrew <nick@nick-andrew.net> wrote:
> >  config CGROUPS
> > [...]
> > +         When enabled, a new filesystem type "cgroup" is available
> > +         and can be mounted to control cpusets.
> How about:
> ... cpusets and other resource/behaviour controllers.

Ok I added that. This is what I have now:


config CGROUPS
        bool "Control Group support"
        help
	  Control Groups enables processes to be tracked and grouped
	  into "cgroups". This enables you, for example, to associate
	  cgroups with certain CPU sets using "cpusets".

	  When enabled, a new filesystem type "cgroup" is available
	  and can be mounted to control cpusets and other
	  resource/behaviour controllers.

	  See <file:Documentation/cgroups.txt> for more information.

	  If unsure, say N.


I don't think that description is as clear as it could be. From
the non-kernel-developer point of view, that is. I'll read
Documentation/cgroups.txt more thoroughly and see if I can come
up with a better description.

Re "other resource/behaviour controllers", what in particular?
I take it that our current controllers are cpusets, scheduler,
CPU accounting and Resource counters?

Nick.
