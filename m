Return-Path: <linux-kernel-owner+w=401wt.eu-S1765536AbXHVQeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765536AbXHVQeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765455AbXHVQdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:33:51 -0400
Received: from namei.org ([69.55.235.186]:40100 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765335AbXHVQdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:33:50 -0400
Date: Wed, 22 Aug 2007 09:33:31 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [2.6.20.17 review 00/58] 2.6.20.17 -stable review
In-Reply-To: <6bffcb0e0708220729j7b9afcf3v4edef68cc974c08d@mail.gmail.com>
Message-ID: <Xine.LNX.4.64.0708220929370.4968@us.intercode.com.au>
References: <20070822083844.%N@1wt.eu>  <6bffcb0e0708220410u4ab3978eq18786ac186e88c7d@mail.gmail.com>
  <Xine.LNX.4.64.0708220621550.28878@us.intercode.com.au> 
 <1187789765.1451.310.camel@moss-spartans.epoch.ncsc.mil> 
 <1187790174.1451.315.camel@moss-spartans.epoch.ncsc.mil> 
 <Xine.LNX.4.64.0708220707390.9414@us.intercode.com.au>
 <6bffcb0e0708220729j7b9afcf3v4edef68cc974c08d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007, Michal Piotrowski wrote:

> On 22/08/07, James Morris <jmorris@namei.org> wrote:
> > On Wed, 22 Aug 2007, Stephen Smalley wrote:
> >
> > > Oops, never mind - tail still follows secmark, so that shouldn't matter.
> > > So I'm not sure why we are getting a bad value for secmark here - should
> > > be initialized to zero and never modified unless there is an iptables
> > > secmark rule.
> >
> > Michal, do you see this in current git?
> 
> No, I do not see this problem in 2.6.23. I had similar problem last
> month, but it is fixed now.
> 
> http://lkml.org/lkml/2007/7/12/362

The previous problem is theoretically unrelated.  It arose via a separate 
mechanism which can't be used at the same as the one you're seeing now in 
the logs.

So this either looks like a problem which has gone unnoticed and was 
inadvertently fixed at some point, or is unique to the 2.6.20 stable 
series.


- James
-- 
James Morris
<jmorris@namei.org>
