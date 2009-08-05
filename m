Return-Path: <linux-kernel-owner+w=401wt.eu-S934493AbZHEOoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934493AbZHEOoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934247AbZHEOoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:44:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:40873 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933707AbZHEOoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:44:03 -0400
Date: Wed, 5 Aug 2009 16:44:02 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com,
       hidehiro.kawai.ez@hitachi.com, linux-arch@vger.kernel.org
Subject: Re: [PATCH] [11/19] HWPOISON: Refactor truncate to allow direct truncating of page v2
Message-ID: <20090805144402.GD23992@wotan.suse.de>
References: <200908051136.682859934@firstfloor.org> <20090805093638.D3754B15D8@basil.firstfloor.org> <20090805102008.GB17190@wotan.suse.de> <20090805134607.GH11385@basil.fritz.box> <20090805140145.GB28563@wotan.suse.de> <20090805141001.GJ11385@basil.fritz.box> <20090805141642.GB23992@wotan.suse.de> <20090805144112.GM11385@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805144112.GM11385@basil.fritz.box>
User-Agent: Mutt/1.5.9i
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

I can't exactly remember. Maybe it was in a thread with Alan and/or
Arjan ;) I don't think the feature itself was questioned as much as
cost/benefit. Maybe I was wrong...

I just want to see everyone is happy with the basic idea ;)


> > Also I will just cc linux-arch. It would be interesting to know whether
> > powerpc, ia64, or s390 or others would be interested to use this feature?
> 
> ia64 is interested (but no code so far) I talked to DaveM and he seems to be 
> interested for sparc too.  I would expect other server architectures to 
> eventually use it as they get around to writing the necessary architecture 
> specific glue.
