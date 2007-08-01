Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbXHASpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbXHASpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761459AbXHASpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:45:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46625 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762281AbXHASpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:45:40 -0400
Date: Wed, 1 Aug 2007 11:45:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Simple Performance Counters: x86_64 support
In-Reply-To: <20070801184026.GC20713@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0708011144450.22867@schroedinger.engr.sgi.com>
References: <11859243121617-git-send-email-clameter@sgi.com>
 <p73ir7zplty.fsf@bingen.suse.de> <Pine.LNX.4.64.0708011052080.20795@schroedinger.engr.sgi.com>
 <20070801182611.GB20713@one.firstfloor.org>
 <Pine.LNX.4.64.0708011127490.22867@schroedinger.engr.sgi.com>
 <20070801184026.GC20713@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007, Andi Kleen wrote:

> > It is certainly interesting to compare alternative ways of handling the 
> > instruction streams by various processors or models of processors.
> 
> Well you have to do a lot more work then to handle instable TSCs then.

I have been using this for 2 years. It works fine for my purposes.

> In particular the frequencies can be different between CPUs, they 
> change (which you can catch with cpufreq notifiers) and during the
> cpufreq change period they're instable (as in you can't tell for
> some time which frequency they're currently running at and they
> might be running immediate frequencies) 

Well then simply make sure that they do not change while you measure.
 
