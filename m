Return-Path: <linux-kernel-owner+w=401wt.eu-S934956AbZDCVwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934956AbZDCVwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZDCVv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:51:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56901 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZDCVv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:51:59 -0400
Date: Fri, 3 Apr 2009 23:53:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Chris Worley <worleys@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
Message-ID: <20090403215351.GF11935@one.firstfloor.org>
References: <f3177b9e0904031302p8aef826u1874a8b9d9af0840@mail.gmail.com> <87vdpljuqi.fsf@basil.nowhere.org> <alpine.DEB.2.00.0904031438540.3646@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904031438540.3646@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 02:43:32PM -0700, David Rientjes wrote:
> On Fri, 3 Apr 2009, Andi Kleen wrote:
> 
> > > Who would be the right person (or list) to talk about this?
> > 
> > Your BIOS vendor whose code reported the wrong values. Not that it matters
> > really on small systems.
> > 
> 
> The numactl --hardware values are coming directly from the sysfs per-node 
> distance interface, so this may not be a result of erroneous BIOS data but 
> rather the lack of a SLIT to describe the physical topology better.

That's the same really. Think about it. No SLIT on a NUMA system is a wrong
SLIT.

BTW there are more cases, like illegal slit which is also replaced
with 10/20.

-Andi
