Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbYDTR5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbYDTR5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 13:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbYDTR5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 13:57:36 -0400
Received: from mail.queued.net ([207.210.101.209]:3091 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909AbYDTR5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 13:57:35 -0400
Date: Sun, 20 Apr 2008 13:59:48 -0400
From: Andres Salomon <dilinger@queued.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com, Mitch Bradley <wmb@firmworks.com>
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
Message-ID: <20080420135948.61bdb4c9@ephemeral>
In-Reply-To: <480B321B.5020802@zytor.com>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	<20080419031024.GC3503@nineveh.local>
	<20080418202925.b18452c5.akpm@linux-foundation.org>
	<20080419092544.378664a8@ephemeral>
	<20080419133909.5aa6b63e@ephemeral>
	<86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>
	<480B321B.5020802@zytor.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008 08:07:55 -0400
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Yinghai Lu wrote:
> > On Sat, Apr 19, 2008 at 10:39 AM, Andres Salomon <dilinger@queued.net> wrote:
> >>  This adds 32-bit support for calling into OFW from the kernel.  It's useful
> >>  for querying the firmware for misc hardware information, fetching the device
> >>  tree, etc.
> >>
> >>  There's potentially no reason why other platforms couldn't use this, but
> >>  currently OLPC is the main user of it.
> >>
> >>  This work was originally done by Mitch Bradley.
> >>
> 
> Hm.  This interface seems more than a bit ad hoc.  In particular, I 
> *really* don't like the swapper_pg_dir hack.
> 
> "There must be a better way."
> 
> 	-hpa

I'm certainly open to suggestions..  Otherwise, I'll poke around and
see if I can come up w/ something.



-- 
Need a kernel or Debian developer?  Contact me, I'm looking for contracts.
