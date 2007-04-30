Return-Path: <linux-kernel-owner+w=401wt.eu-S1030934AbXD3LXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030934AbXD3LXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030948AbXD3LXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:23:12 -0400
Received: from ns2.suse.de ([195.135.220.15]:46424 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030934AbXD3LXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:23:08 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] [39/40] i386: Export paravirt_ops for non GPL modules too
Date: Mon, 30 Apr 2007 13:19:54 +0200
User-Agent: KMail/1.9.6
Cc: Christoph Hellwig <hch@infradead.org>, mingo@elte.hu, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <200704301227.598020000@suse.de> <200704301300.31298.ak@suse.de> <Pine.LNX.4.61.0704301315080.29151@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704301315080.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301319.54291.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2007 13:15:36 Jan Engelhardt wrote:
> 
> On Apr 30 2007 13:00, Andi Kleen wrote:
> >On Monday 30 April 2007 12:50:09 Christoph Hellwig wrote:
> >> On Mon, Apr 30, 2007 at 12:28:14PM +0200, Andi Kleen wrote:
> >> > 
> >> > Otherwise non GPL modules cannot even do basic operations
> >> > like disabling interrupts anymore, which would be excessive.
> >> > 
> >> > Longer term should split the single structure up into
> >> > internal and external symbols and not export the internal
> >> > ones at all.
> >> > 
> >> > Signed-off-by: Andi Kleen <ak@suse.de>
> >> 
> >> Ingo was dead-set against this and I kinda agree. 
> >
> >The problem is that without this non GPL modules cannot even disable
> >interrupts anymore. That is imho too radical.
> 
> Perhaps we can have a paravirt_ops2 that specifically deals with
> interrupt en/disable, and export that instead?

Yes that is what the "Longer term ..." paragraph above refers to.
However it would need some restructuring in the code.

-Andi
