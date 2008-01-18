Return-Path: <linux-kernel-owner+w=401wt.eu-S1762718AbYARQfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762718AbYARQfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761404AbYARQe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:34:57 -0500
Received: from mail.suse.de ([195.135.220.2]:45613 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761390AbYARQe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:34:56 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr patch series v3)
Date: Fri, 18 Jan 2008 17:34:51 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, jbeulich@novell.com,
       venkatesh.pallipadi@intel.com
References: <200801161114.239449000@suse.de> <200801181716.06093.ak@suse.de> <20080118162118.GA6819@elte.hu>
In-Reply-To: <20080118162118.GA6819@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181734.51193.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 17:21:18 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > > > (except for the white space changes, but that can be redone once 
> > > > everything settled down again). Then it will be bisectable.
> > > 
> > > it's a revert barrier (within v2.6.25),
> > 
> > What is a revert barrier?
> >
> > Anyways of course the way to handle that is the same as with the other 
> > undo patches: drop the original white space changes 
> > (ddb53b5735793a19dc17bcd98b050f672f) completely and then drop that 
> > undo patch too. The white space changes haven't reached Linus yet so 
> > you can just make them disappear completely from known history.
> 
> we dont want them to disappear, due to the second half of:
> 
>    http://lkml.org/lkml/2008/1/18/112

<reads the new gospel> 

> we want easy-cleanups first, difficult changes applied second. It's a 
> well-established concept.

That rule of thumb makes sense if someone does a series from scratch, but 
redoing a large existing series just because someone else sneaked in a white space
patch at the wrong time does not seem to be very efficient to me.

After all these rules are not to make our lives more complicated,
but to to make things more efficient.

And most of the code in the white space cleanup changes anyways in the later 
CPA series.

And what is left you'll get them again anyways once the CPA stuff is 
in and people tested it a bit more so it has settled down.

I promise to redo them on top of the end result.

-Andi
