Return-Path: <linux-kernel-owner+w=401wt.eu-S1762186AbXHAS5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762186AbXHAS5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXHAS5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:57:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51436 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbXHAS5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:57:43 -0400
Date: Wed, 1 Aug 2007 20:57:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Simple Performance Counters: x86_64 support
Message-ID: <20070801185741.GD20713@one.firstfloor.org>
References: <11859243121617-git-send-email-clameter@sgi.com> <p73ir7zplty.fsf@bingen.suse.de> <Pine.LNX.4.64.0708011052080.20795@schroedinger.engr.sgi.com> <20070801182611.GB20713@one.firstfloor.org> <Pine.LNX.4.64.0708011127490.22867@schroedinger.engr.sgi.com> <20070801184026.GC20713@one.firstfloor.org> <Pine.LNX.4.64.0708011144450.22867@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708011144450.22867@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 11:45:39AM -0700, Christoph Lameter wrote:
> On Wed, 1 Aug 2007, Andi Kleen wrote:
> 
> > > It is certainly interesting to compare alternative ways of handling the 
> > > instruction streams by various processors or models of processors.
> > 
> > Well you have to do a lot more work then to handle instable TSCs then.
> 
> I have been using this for 2 years. It works fine for my purposes.

That might be on your systems, but for a mainline submission the
standards are higher.

> 
> > In particular the frequencies can be different between CPUs, they 
> > change (which you can catch with cpufreq notifiers) and during the
> > cpufreq change period they're instable (as in you can't tell for
> > some time which frequency they're currently running at and they
> > might be running immediate frequencies) 
> 
> Well then simply make sure that they do not change while you measure.

That would be a merge blocker in my opinion. Suitable for local
hacks, but nothing we want in tree.

-Andi

