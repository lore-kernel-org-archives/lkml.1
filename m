Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbYENUdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbYENUdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbYENUdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:33:45 -0400
Received: from relay2.sgi.com ([192.48.171.30]:44216 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752635AbYENUdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:33:42 -0400
Date: Wed, 14 May 2008 13:33:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <1210794563.4093.57.camel@calx>
Message-ID: <Pine.LNX.4.64.0805141333060.18231@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com>  <20080510030919.604216074@sgi.com>
 <4825709A.2020407@firstfloor.org>  <20080510221515.3540a6cc@bree.surriel.com>
  <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com> 
 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com> 
 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com> 
 <482B2617.5010605@firstfloor.org>  <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
  <1210789112.4093.14.camel@calx>  <Pine.LNX.4.64.0805141220440.16223@schroedinger.engr.sgi.com>
 <1210794563.4093.57.camel@calx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Matt Mackall wrote:

> > allocator?
> 
> No, slow path here means we're already under memory pressure, so we
> don't care if something takes longer if it saves memory.

So expire the queues under memory pressure only? Trigger queue cleanup 
from reclaim?


