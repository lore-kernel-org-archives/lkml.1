Return-Path: <linux-kernel-owner+w=401wt.eu-S1765392AbXJOSvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765392AbXJOSvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759106AbXJOSve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:51:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34423 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758781AbXJOSvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:51:33 -0400
Date: Mon, 15 Oct 2007 11:51:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org, Albert Cahalan <acahalan@gmail.com>
Subject: Re: How to find slab\'s usage?
In-Reply-To: <84144f020710130110r6b13389aj43bb7b79ecd5e1b7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710151150530.25274@schroedinger.engr.sgi.com>
References: <200710120701.l9C71Jx6038998@www262.sakura.ne.jp> 
 <84144f020710130043v4f8e4cfbm178c88478d4b053d@mail.gmail.com> 
 <200710131702.FHD09857.VSQOLFtFOJHMFO@I-love.SAKURA.ne.jp>
 <84144f020710130110r6b13389aj43bb7b79ecd5e1b7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007, Pekka Enberg wrote:

> Hi,
> 
> On 10/12/07, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > > > I saw /proc/meminfo and it seems to me that slab is leaking memory.
> > > > But /usr/bin/slabtop claims /proc/slabinfo is missing.
> 
> At some point in time, I wrote:
> > > Do you have CONFIG_SLUB enabled? Try looking into /sys/slab/.
> 
> On 10/13/07, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > Yes. There is /sys/slab/ .
> > But are there any tools for browsing like /usr/bin/slabtop ?
> > Is
> >   cd /sys/slab/; for i in *; do echo -n $i " "; cat $i/slabs; done
> > the only way currently available?

There is a tool in Documentation/vm/slabinfo.c. Just compile that.

> I don't think slabtop in procps has been updated to support slub. Christoph?

slabinfo can probably do much of what slabtop does.

