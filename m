Return-Path: <linux-kernel-owner+w=401wt.eu-S1759584AbYFKUbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbYFKUbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758816AbYFKUaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:30:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759061AbYFKUaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:30:20 -0400
Date: Wed, 11 Jun 2008 16:30:07 -0400
From: Rik van Riel <riel@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 11/24] pageflag helpers for configed-out flags
Message-ID: <20080611163007.4eae7f16@bree.surriel.com>
In-Reply-To: <1213215827.6436.61.camel@lts-notebook>
References: <20080611184214.605110868@redhat.com>
	<20080611184339.493423475@redhat.com>
	<20080611130145.2a202339.akpm@linux-foundation.org>
	<20080611160814.5374467d@bree.surriel.com>
	<1213215827.6436.61.camel@lts-notebook>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 16:23:47 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> On Wed, 2008-06-11 at 16:08 -0400, Rik van Riel wrote:
> > On Wed, 11 Jun 2008 13:01:45 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Wed, 11 Jun 2008 14:42:25 -0400
> > > Rik van Riel <riel@redhat.com> wrote:
> > > 
> > > > Define proper false/noop inline functions for noreclaim page
> > > > flags when !defined(CONFIG_NORECLAIM_LRU)
> > > 
> > > I changed that to CONFIG_UNEVICTABLE_LRU.
> > > 
> > > Did we agree that the presence of this config variable is undesirable? 
> > > If so, what's involved in making it go away?
> > 
> > We agreed that having CONFIG_NORELAIM_SWAP was bad, that one went away.
> 
> That was CONFIG_NORELAIM_MLOCK, right?

You're right.

> Which reminds me:  we'll need to change the description of
> CONFIG_UNEVICTABLE_LRU to state that it uses 2 page flags if, indeed, we
> want to say anything about page flag usage in the Kconfig help text.
> Not sure that's helpful.

True, we might as well remove that comment.

-- 
All rights reversed.
