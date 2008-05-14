Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYENVBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYENVBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYENVAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:00:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47347 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752116AbYENVAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:00:17 -0400
Date: Wed, 14 May 2008 14:00:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <20080514205842.GC9921@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0805141359420.18958@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com> <20080510030919.604216074@sgi.com>
 <4825709A.2020407@firstfloor.org> <20080510221515.3540a6cc@bree.surriel.com>
 <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
 <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141104260.15633@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0805141333550.18231@schroedinger.engr.sgi.com>
 <20080514205842.GC9921@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Matthew Wilcox wrote:

> On Wed, May 14, 2008 at 01:46:52PM -0700, Christoph Lameter wrote:
> > Some more on SMP scaling:
> 
> These are all great theories, and you mentioned that you'd fixed the
> regressions with tbench, but did you fix the regression with the io-gen
> program I sent you?

No. I thought you were satisfied with the performance increase you saw 
when pinning the process to a single processor?

