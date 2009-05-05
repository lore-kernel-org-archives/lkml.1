Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbZEEMsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbZEEMsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 08:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbZEEMsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 08:48:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890AbZEEMr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 08:47:59 -0400
Date: Tue, 5 May 2009 14:47:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Oliver Neukum <oliver@neukum.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input <linux-input@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: lockdep report at resume
In-Reply-To: <1240323968.17388.22.camel@johannes.local>
Message-ID: <alpine.LNX.2.00.0905051446520.22532@wotan.suse.de>
References: <1234022517.4175.107.camel@johannes.local>  <1238578840.5970.178.camel@johannes.local>  <alpine.LNX.2.00.0904211550280.13028@wotan.suse.de>  <200904211559.43497.oliver@neukum.org>  <alpine.LNX.2.00.0904211609220.13028@wotan.suse.de>
 <1240323968.17388.22.camel@johannes.local>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009, Johannes Berg wrote:

> > > > [ thanks for the analysis Johannes ... involving also Oliver here; really
> > > >   seems like a false positive to me ]
> > > I think he's right. But as a matter of principle I'd like to see 
> > > flush_scheduled_work() avoided where possible, hence the patch.
> > I am not entirely sure that this is the same issue as the one from #13136 
> > of kernel.org bugzilla.
> > Anyway, for reference, the patch Oliver mentioned here is below.
> Thanks. Unfortunately I have another problem that turns off lockdep so I
> can't test this right now, sorry.

Are you able to reproduce the problem with current git (the expected fix 
is 89092ddd7a).

Thanks,

-- 
Jiri Kosina
SUSE Labs
