Return-Path: <linux-kernel-owner+w=401wt.eu-S934609AbZHEPAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609AbZHEPAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934583AbZHEPAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:00:40 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49790 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075AbZHEPAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:00:39 -0400
Date: Wed, 5 Aug 2009 09:00:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@suse.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, hidehiro.kawai.ez@hitachi.com,
       linux-arch@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: [PATCH] [11/19] HWPOISON: Refactor truncate to allow direct
	truncating of page v2
Message-ID: <20090805150038.GL3711@parisc-linux.org>
References: <200908051136.682859934@firstfloor.org> <20090805093638.D3754B15D8@basil.firstfloor.org> <20090805102008.GB17190@wotan.suse.de> <20090805134607.GH11385@basil.fritz.box> <20090805140145.GB28563@wotan.suse.de> <20090805141001.GJ11385@basil.fritz.box> <20090805141642.GB23992@wotan.suse.de> <20090805144112.GM11385@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805144112.GM11385@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 04:41:12PM +0200, Andi Kleen wrote:
> > One question I had for the others (Andrew? other mm guys?) what is the
> > feelings of merging this feature? Leaving aside exact implementation
> > and just considering the high level design and cost/benefit. Last time
> > there were some people objecting, so I wonder the situation now? So
> > does anybody need more convincing? :)
> 
> The main objection last time was that it was a bit too late in the 
> release schedule.
> 
> I can't remember anyone really questioning the basic feature itself.
> 
> > Also I will just cc linux-arch. It would be interesting to know whether
> > powerpc, ia64, or s390 or others would be interested to use this feature?
> 
> ia64 is interested (but no code so far) I talked to DaveM and he seems to be 
> interested for sparc too.  I would expect other server architectures to 
> eventually use it as they get around to writing the necessary architecture 
> specific glue.

parisc could certainly implement this.  Don't know if there's interest.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
