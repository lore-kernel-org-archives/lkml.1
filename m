Return-Path: <linux-kernel-owner+w=401wt.eu-S1750787AbXBWEzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750787AbXBWEzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 23:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbXBWEzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 23:55:50 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57625 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750787AbXBWEzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 23:55:50 -0500
Date: Thu, 22 Feb 2007 20:55:41 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: Andi Kleen <andi@firstfloor.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: SLUB: The unqueued Slab allocator
In-Reply-To: <20070223001653.GA16108@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0702222053540.24461@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702212250271.30485@schroedinger.engr.sgi.com>
 <p73hctecc3l.fsf@bingen.suse.de> <Pine.LNX.4.64.0702221040140.2011@schroedinger.engr.sgi.com>
 <20070223001653.GA16108@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007, Andi Kleen wrote:

> If you don't cache constructed but free objects then there is no cache
> advantage of constructors/destructors and they would be useless.

SLUB caches those objects as long as they are part of a partially 
allocated slab. If all objects in the slab are freed then the whole slab 
will be freed. SLUB does not keep queues of freed slabs.

