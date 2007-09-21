Return-Path: <linux-kernel-owner+w=401wt.eu-S1762821AbXIUUGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762821AbXIUUGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbXIUUGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:06:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:12621 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbXIUUGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:06:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=oqDy09rATIrie3teFsg6e+b8iZ1rUCV0pfG/Qn+hucBD0cxpEimqbcWMbJrc91m07
	+zfoWMoFiD2S/LhVRo1Ag==
Date: Fri, 21 Sep 2007 13:06:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: linux-kernel@vger.kernel.org, andrea@suse.de, clameter@sgi.com,
       akpm@osdl.org
Subject: Re: + oom-move-constraints-to-enum.patch added to -mm tree
In-Reply-To: <20070921200026.GD1857@martell.zuzino.mipt.ru>
Message-ID: <alpine.DEB.0.9999.0709211305070.8826@chino.kir.corp.google.com>
References: <200709210910.l8L9Avh2028189@imap1.linux-foundation.org> <20070921200026.GD1857@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2007, Alexey Dobriyan wrote:

> On Fri, Sep 21, 2007 at 02:10:57AM -0700, akpm@linux-foundation.org wrote:
> > The OOM killer's CONSTRAINT definitions are really more appropriate in an
> > enum, so define them in include/linux/oom.h.
> 
> OK with enum, but this series do not bring user outside of
> mm/oom_kill.c, so why move them to header.
> 

I'm not ruling it out, it may be helpful to pass the enum to 
out_of_memory() when we serialize based on GFP_DMA allocations or memory 
policies.
