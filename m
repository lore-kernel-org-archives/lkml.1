Return-Path: <linux-kernel-owner+w=401wt.eu-S1762987AbYENSF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762987AbYENSF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 14:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758309AbYENSFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 14:05:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:35577 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755412AbYENSFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 14:05:15 -0400
Date: Wed, 14 May 2008 11:05:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <482B2617.5010605@firstfloor.org>
Message-ID: <Pine.LNX.4.64.0805141104260.15633@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com>  <20080510030919.604216074@sgi.com>
 <4825709A.2020407@firstfloor.org>  <20080510221515.3540a6cc@bree.surriel.com>
  <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
 <482B2617.5010605@firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Andi Kleen wrote:

> Ignoring NUMA is no option unfortunately. And with integrated memory
> controller many of the remote CPU frees are off node.

The issue of object expiration holdoffs also affects applications 
running on pure SMP systems.
