Return-Path: <linux-kernel-owner+w=401wt.eu-S1758405AbXENHQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbXENHQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 03:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXENHQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 03:16:19 -0400
Received: from odin.sis.hu ([212.92.23.29]:48060 "EHLO odin.sis.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXENHQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 03:16:18 -0400
X-Spam-Score: -0.001
Date: Mon, 14 May 2007 09:16:11 +0200
From: Gabor Burjan <buga@buvoshetes.hu>
To: Patrick McHardy <kaber@trash.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: kernel oops after unloading nf_conntrack_netbios_ns_module
Message-ID: <20070514071611.GA8864@odin.sis.hu>
References: <20070510090603.GA13059@odin.sis.hu> <20070510033411.6cf042ad.akpm@linux-foundation.org> <20070510110117.GE13059@odin.sis.hu> <4645D7CF.20707@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4645D7CF.20707@trash.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 05:05:51PM +0200, Patrick McHardy wrote:
> Gabor Burjan wrote:
> > EIP is at destroy_conntrack+0x52/0x127 [nf_conntrack]
> >
> >>>nmblookup <existing_netbios_name>
> >>>cat /proc/net/ip_conntrack
> >>>
> >>>sleep 3
> >>>
> >>>rmmod nf_conntrack_netbios_ns
> 
> Thanks for the report and good testcase, the crash can only happen with
> a sleep of >= 3s after the last nmblookup packet was sent.
> 
> Can you try if this patch fixes it please?

Yes, it fixes the problem.
Thank you,

Gabor
