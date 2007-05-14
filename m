Return-Path: <linux-kernel-owner+w=401wt.eu-S1760571AbXENWPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760571AbXENWPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbXENWPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:15:18 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760038AbXENWPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:15:15 -0400
Date: Mon, 14 May 2007 15:14:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabor Burjan <buga@buvoshetes.hu>
Cc: Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: kernel oops after unloading nf_conntrack_netbios_ns_module
Message-Id: <20070514151434.a48fa153.akpm@linux-foundation.org>
In-Reply-To: <20070514071611.GA8864@odin.sis.hu>
References: <20070510090603.GA13059@odin.sis.hu>
	<20070510033411.6cf042ad.akpm@linux-foundation.org>
	<20070510110117.GE13059@odin.sis.hu>
	<4645D7CF.20707@trash.net>
	<20070514071611.GA8864@odin.sis.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 09:16:11 +0200
Gabor Burjan <buga@buvoshetes.hu> wrote:

> On Sat, May 12, 2007 at 05:05:51PM +0200, Patrick McHardy wrote:
> > Gabor Burjan wrote:
> > > EIP is at destroy_conntrack+0x52/0x127 [nf_conntrack]
> > >
> > >>>nmblookup <existing_netbios_name>
> > >>>cat /proc/net/ip_conntrack
> > >>>
> > >>>sleep 3
> > >>>
> > >>>rmmod nf_conntrack_netbios_ns
> > 
> > Thanks for the report and good testcase, the crash can only happen with
> > a sleep of >= 3s after the last nmblookup packet was sent.
> > 
> > Can you try if this patch fixes it please?
> 
> Yes, it fixes the problem.

Just speaking generally, rather than about this particualr patch...

Gabor did quite an amount of valuable work here: tested a 2.6.20.x kernel,
developed a test case for reproducing the bug, reported it all quite
exhaustively, tested the resulting patch.

The least we can do in return is to put a big fat "thanks" in the changelog
when the fix gets merged.

> Thank you,

No - thank _you_.
