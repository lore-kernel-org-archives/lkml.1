Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbYFKUX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbYFKUX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYFKUXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:23:22 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:31439 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYFKUXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:23:21 -0400
Subject: Re: [PATCH -mm 11/24] pageflag helpers for configed-out flags
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080611160814.5374467d@bree.surriel.com>
References: <20080611184214.605110868@redhat.com>
	 <20080611184339.493423475@redhat.com>
	 <20080611130145.2a202339.akpm@linux-foundation.org>
	 <20080611160814.5374467d@bree.surriel.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 11 Jun 2008 16:23:47 -0400
Message-Id: <1213215827.6436.61.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-11 at 16:08 -0400, Rik van Riel wrote:
> On Wed, 11 Jun 2008 13:01:45 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 11 Jun 2008 14:42:25 -0400
> > Rik van Riel <riel@redhat.com> wrote:
> > 
> > > Define proper false/noop inline functions for noreclaim page
> > > flags when !defined(CONFIG_NORECLAIM_LRU)
> > 
> > I changed that to CONFIG_UNEVICTABLE_LRU.
> > 
> > Did we agree that the presence of this config variable is undesirable? 
> > If so, what's involved in making it go away?
> 
> We agreed that having CONFIG_NORELAIM_SWAP was bad, that one went away.

That was CONFIG_NORELAIM_MLOCK, right?

Which reminds me:  we'll need to change the description of
CONFIG_UNEVICTABLE_LRU to state that it uses 2 page flags if, indeed, we
want to say anything about page flag usage in the Kconfig help text.
Not sure that's helpful.

> 
> As for CONFIG_UNEVICTABLE_LRU, I believe we will want to at least give
> embedded people the option to compile without all that code, similar
> to CONFIG_SWAP.

Agree.

Lee

