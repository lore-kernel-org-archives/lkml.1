Return-Path: <linux-kernel-owner+w=401wt.eu-S966668AbYD1T0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966668AbYD1T0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965008AbYD1T0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:26:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964801AbYD1T0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:26:05 -0400
Subject: Re: [PATCH] x86: create array based interface to chagne page
	attribute
From: Dave Airlie <airlied@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, arjan@linux.intel.com
In-Reply-To: <20080428181257.GA2242@elte.hu>
References: <1209202037-6513-1-git-send-email-airlied@redhat.com>
	 <20080426095115.GA15212@elte.hu> <20080426141718.GA10936@elte.hu>
	 <alpine.DEB.0.82.0804262323520.26860@skynet.skynet.ie>
	 <20080428134759.GE3973@elte.hu>  <20080428181257.GA2242@elte.hu>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 05:25:39 +1000
Message-Id: <1209410739.26244.1.camel@optimus>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-8.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 20:12 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Dave Airlie <airlied@linux.ie> wrote:
> > 
> > > one-liner attached.
> > 
> > applied, thanks.
> 
> x86.git randconfig boot testing found hard lockups and crashes. Bisected 
> it down to your patch. Config and crashlog at:
> 
>   http://redhat.com/~mingo/misc/log-Mon_Apr_28_20_00_50_CEST_2008.bad
>   http://redhat.com/~mingo/misc/config-Mon_Apr_28_20_00_50_CEST_2008.bad
> 
> (can send more info if you need it.)
> 

Well drop the patch for now, I'll commit some more serious time to it
when I get back online properly in a 3-4 days time...

I can't see what else I could have messed up since I rebased the patch
on top of the latest x86 tree..

Dave.

