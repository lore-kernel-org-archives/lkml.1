Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYE1GLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYE1GLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 02:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYE1GLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 02:11:35 -0400
Received: from ns.suse.de ([195.135.220.2]:60811 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbYE1GLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 02:11:34 -0400
Date: Wed, 28 May 2008 08:11:30 +0200
From: Nick Piggin <npiggin@suse.de>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: Why is the rewritten ramdisk driver called brd instad of rd
Message-ID: <20080528061130.GB16441@wotan.suse.de>
References: <20080321130552.GA28274@lst.de> <1211880480.29836.11.camel@elijah.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211880480.29836.11.camel@elijah.suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 11:28:00AM +0200, Petr Tesarik wrote:
> On Fri, 2008-03-21 at 14:05 +0100, Christoph Hellwig wrote:
> > Any reason why the rewritten ramdisk driver has a new name?  It's for
> > all matters an inplace replacement of the old rd driver so it should
> > be called rd.c / rd.ko to not confused instaler/developers/etc.
> 
> I think it's because the old rd played some dirty tricks with the page
> cache, while the reworked one is a straightforward implementation of a
> normal _b_lock device -> hence the "b".
> 
> No guarantee of correctness.

Yeah it was a rwrite from scratch and it lived with the rd.c code for
a while (although maybe never in mainline). I guess it might be good
idea to rename it back to rd?

