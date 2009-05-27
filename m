Return-Path: <linux-kernel-owner+w=401wt.eu-S1761762AbZE0TTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761762AbZE0TTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760636AbZE0TTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:19:43 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:29068 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822AbZE0TTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:19:42 -0400
Date: Wed, 27 May 2009 14:26:37 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [TuxOnIce-devel] [RFC] TuxOnIce
In-reply-to: <1243382551.13930.109.camel@nigel-laptop>
Message-id: <alpine.LFD.2.00.0905271411570.4277@localhost.localdomain>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
 <200905260039.43626.rjw@sisk.pl> <1243298374.16743.161.camel@nigel-laptop>
 <200905270027.41898.rjw@sisk.pl> <1243382551.13930.109.camel@nigel-laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The possibilities I see are:
> > > 
> > > 1) Assume we can't know exactly how much but can allow a ball-park
> > > figure (current method)
> > > 2) Implement a means by which components that might allocate memory can
> > > tell us how much they might allocate (currently used internally by
> > > tuxonice - part of the modular design). I'd love to see this for the
> > > drivers' suspend code.
> > 
> > The drivers' suspend code is too late, we need to know that before the drivers'
> > suspend callbacks are run.
> 
> Yeah, sorry for not being clear enough. I meant I'd like to see a new
> function in the API that lets us enquire early on as to how much memory
> will be needed. That said, I like the idea of just asking them to
> allocate memory earlier better.

The more we require of driver writers, the more likely it is that
they'll get it wrong and we will fail.

I believe it must remain a fundamental design goal that
the correctness burden on driver writers be as small as possible.

Of couse if optional hooks are availalble for an unusual driver that has
special requirements, that is fine, as long as unusual really is unusual.

thanks,
Len Brown, Intel Open Source Technology Center
