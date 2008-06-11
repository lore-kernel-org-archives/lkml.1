Return-Path: <linux-kernel-owner+w=401wt.eu-S1758493AbYFKUJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbYFKUJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbYFKUJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:09:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbYFKUJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:09:01 -0400
Date: Wed, 11 Jun 2008 16:08:14 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 11/24] pageflag helpers for configed-out flags
Message-ID: <20080611160814.5374467d@bree.surriel.com>
In-Reply-To: <20080611130145.2a202339.akpm@linux-foundation.org>
References: <20080611184214.605110868@redhat.com>
	<20080611184339.493423475@redhat.com>
	<20080611130145.2a202339.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 13:01:45 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 11 Jun 2008 14:42:25 -0400
> Rik van Riel <riel@redhat.com> wrote:
> 
> > Define proper false/noop inline functions for noreclaim page
> > flags when !defined(CONFIG_NORECLAIM_LRU)
> 
> I changed that to CONFIG_UNEVICTABLE_LRU.
> 
> Did we agree that the presence of this config variable is undesirable? 
> If so, what's involved in making it go away?

We agreed that having CONFIG_NORELAIM_SWAP was bad, that one went away.

As for CONFIG_UNEVICTABLE_LRU, I believe we will want to at least give
embedded people the option to compile without all that code, similar
to CONFIG_SWAP.

-- 
All rights reversed.
