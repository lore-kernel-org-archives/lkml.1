Return-Path: <linux-kernel-owner+w=401wt.eu-S933199AbXHIVU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbXHIVU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbXHIVUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:20:08 -0400
Received: from mail.suse.de ([195.135.220.2]:45158 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756243AbXHIVUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:20:06 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] Use one zonelist per node instead of multiple zonelists v2
Date: Thu, 9 Aug 2007 23:20:01 +0200
User-Agent: KMail/1.9.6
Cc: Mel Gorman <mel@csn.ul.ie>, Lee.Schermerhorn@hp.com, pj@sgi.com,
       kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20070808161504.32320.79576.sendpatchset@skynet.skynet.ie> <20070809131943.64cb0921.akpm@linux-foundation.org>
In-Reply-To: <20070809131943.64cb0921.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708092320.01669.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2007 22:19:43 Andrew Morton wrote:
> On Wed,  8 Aug 2007 17:15:04 +0100 (IST)
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > The following patches replace multiple zonelists per node with one zonelist
> > that is filtered based on the GFP flags.
> 
> I think I'll duck this for now on im-trying-to-vaguely-stabilize-mm grounds.
> Let's go with the horrible-hack for 2.6.23, then revert it and get this
> new approach merged and stabilised over the next week or two?

I would prefer to not have horrible hacks even temporary

-Andi



