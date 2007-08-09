Return-Path: <linux-kernel-owner+w=401wt.eu-S934013AbXHICST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013AbXHICST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 22:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbXHICSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 22:18:07 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:56922 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbXHICSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 22:18:06 -0400
Date: Wed, 8 Aug 2007 22:17:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>
Subject: Re: [PATCH 2/7] Added generic lg.h in lguest directory.
In-Reply-To: <20070809114528.da47fd77.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.58.0708082214300.19189@gandalf.stny.rr.com>
References: <20070809003211.373543702@goodmis.org> <20070809003343.310187242@goodmis.org>
 <20070809114528.da47fd77.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--
On Thu, 9 Aug 2007, Stephen Rothwell wrote:

> On Wed, 08 Aug 2007 20:32:13 -0400 Steven Rostedt <rostedt@goodmis.org>
> wrote:
> >
> > Add a generic lg.h file to call the architecture specific one.
>
> Please combine this with the previous patch so that the tree will build
> at each step.

Yeah, I wanted to do that, but git got confused when I did that, and did
what I didn't want. That was, created a new file in the i386 directory,
and diffed the one in this directory.

I'm really want to keep git knowing the history of the file on moving. I
could just simply cat the two files instead. Would that be acceptible?

-- Steve

