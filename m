Return-Path: <linux-kernel-owner+w=401wt.eu-S1030784AbXHMNg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030784AbXHMNg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971988AbXHMJvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:51:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52597 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S969062AbXHMJvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:51:50 -0400
Message-ID: <46C02973.6030709@sgi.com>
Date: Mon, 13 Aug 2007 11:50:43 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070719)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Carsten Otte <cotte@de.ibm.com>
Subject: Re: [PATCH 0/7] Modify lguest32 to make room for lguest64
References: <20070809003211.373543702@goodmis.org> <1186803724.30899.62.camel@localhost.localdomain>
In-Reply-To: <1186803724.30899.62.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Yeah, after some more thought I've not applied most of this.  We really
> don't want to move everything then move it back; I prefer Jes' more
> cautious approach of moving a little bit at a time.
> 
> We really have three parts: (1) bits that are generic, (2) bits that
> should be generic but my implementation is naive, (3) bits that really
> are i386-specific.

I have actually been using Steven's patchset to do my work, but in a
way it's a tool. Moving things out of the way in bulk and see whats
missing kinda helps for that :)

> Patches which move 2 to 1 are gratefully accepted: I realize a mass move
> is easier and this requires thought, but that's what we need.
> 
> Since I can't build a module over two directories, that seems to destroy
> the idea of an i386/ subdir.  Instead I've done a patch which renames
> the *clearly* i386-specific things to i386_<name>, which at least works.
> I've pushed it into the repository http://lguest.ozlabs.org/patches/

That works - alternatively we could build two modules, lg and lg_<arch>
and just have lg pull in the arch one as well? I'm not really biased,
but I think it will get messy later once we add ia64 and x86_64 to the
directory.

Cheers,
Jes

