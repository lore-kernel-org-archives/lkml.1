Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYG2AD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYG2AD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbYG2ADS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:03:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbYG2ADR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:03:17 -0400
Date: Mon, 28 Jul 2008 20:03:11 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: PERF: performance tests with the split LRU VM in -mm
Message-ID: <20080728200311.2218af4e@cuia.bos.redhat.com>
In-Reply-To: <20080728195713.42cbceed@cuia.bos.redhat.com>
References: <20080724222510.3bbbbedc@bree.surriel.com>
	<20080728105742.50d6514e@cuia.bos.redhat.com>
	<20080728164124.8240eabe.akpm@linux-foundation.org>
	<20080728195713.42cbceed@cuia.bos.redhat.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 19:57:13 -0400
Rik van Riel <riel@redhat.com> wrote:
> On Mon, 28 Jul 2008 16:41:24 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > Andrew, what is your preference between:
> > > 	http://lkml.org/lkml/2008/7/15/465
> > > and
> > > 	http://marc.info/?l=linux-mm&m=121683855132630&w=2
> > > 
> > 
> > Boy.  They both seem rather hacky special-cases.  But that doesn't mean
> > that they're undesirable hacky special-cases.  I guess the second one
> > looks a bit more "algorithmic" and a bit less hacky-special-case.  But
> > it all depends on testing..
> 
> I prefer the second one, since it removes the + 1 magic (at least,
> for the higher priorities), instead of adding new magic like the
> other patch does.

Btw, didn't you add that "+ 1" originally early on in the 2.6 VM?

Do you remember its purpose?  

Does it still make sense to have that "+ 1" in the split LRU VM?

Could we get away with just removing it unconditionally?

-- 
All Rights Reversed
