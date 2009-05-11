Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZEKTdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZEKTdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbZEKTdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:33:00 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31779 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbZEKTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:32:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=djlBDQx84zO4eMb31jYI/gVrIWbO9CIsxxzhtUWmMrxeBpjLBiSmGv6vIj6zyleNL
	jRuHFW9W4tUQ4mfKXH+LQ==
Date: Mon, 11 May 2009 12:32:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mmotm] mm: invoke oom killer for __GFP_NOFAIL
In-Reply-To: <28c262360905110700p68f3de35xf0a1d52d2ccfd968@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0905111229540.23739@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com> <20090511162900.f372edd1.minchan.kim@barrios-desktop> <alpine.DEB.2.00.0905110138160.24726@chino.kir.corp.google.com> <28c262360905110212j9867b79wd8d90b16f6f196be@mail.gmail.com>
 <28c262360905110421g1b079f2cr798ca95adfb8ee45@mail.gmail.com> <20090511133840.GA11624@csn.ul.ie> <28c262360905110700p68f3de35xf0a1d52d2ccfd968@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Minchan Kim wrote:

> But this patch increases the probability of innocent task killing.
> Is GFP_NOFAIL's early bailout more important than killing of innocent task ?
> 

__GFP_NOFAIL's bailout is, by definition, a bug in the page allocator and 
this patch fixes it.
