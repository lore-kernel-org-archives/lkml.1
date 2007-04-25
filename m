Return-Path: <linux-kernel-owner+w=401wt.eu-S2993074AbXDYURM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993074AbXDYURM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993076AbXDYURM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:17:12 -0400
Received: from ns.suse.de ([195.135.220.2]:34519 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993074AbXDYURL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:17:11 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 06/25] xen: Core Xen implementation
Date: Wed, 25 Apr 2007 22:17:06 +0200
User-Agent: KMail/1.9.6
Cc: Ian Pratt <ian.pratt@xensource.com>, lkml <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <20070423215638.563901986@goop.org> <200704252143.48363.ak@suse.de> <462FB42F.5070503@goop.org>
In-Reply-To: <462FB42F.5070503@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704252217.06381.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > To summarize the outstanding issues are:
> > - fixing sched_clock first
> >   
> 
> What was the sched_clock problem?  I don't remember and outstanding
> issues with it.  I noticed you didn't take paravirt-sched_clock.

The major problem was that it didn't compile on x86-64.
And a few uglities in there so I was not too unhappy to drop.

-Andi
