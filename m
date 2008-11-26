Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYKZDi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYKZDi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 22:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYKZDiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 22:38:20 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:49156 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbYKZDiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 22:38:19 -0500
Date: Tue, 25 Nov 2008 20:38:16 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, dwmw2@infradead.org,
       jens.axboe@oracle.com, joern@logfs.org,
       James.Bottomley@HansenPartnership.com, djshin90@gmail.com,
       teheo@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] swapfile: swapon randomize if nonrot
Message-ID: <20081126033815.GF25548@parisc-linux.org>
References: <Pine.LNX.4.64.0811252132580.17555@blonde.site> <Pine.LNX.4.64.0811252140230.17555@blonde.site> <Pine.LNX.4.64.0811252146090.20455@blonde.site> <20081125172039.c9a35460.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125172039.c9a35460.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 05:20:39PM -0800, Andrew Morton wrote:
> On Tue, 25 Nov 2008 21:46:56 +0000 (GMT)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > But how to get my SD card, accessed by USB card reader, reported as NONROT?
> 
> Dunno.  udev rules, perhaps?

I didn't see patch 8/9, but the 'non-rotating' bit is in word 217 of the
inquiry data.  Unfortunately, Jeff insisted that we only report the
contents of that bit for devices claiming ATA-8 support, which is
ridiculous as even the Intel SSDs only claim conformance to ATA-7.

I notice that Jens was allowed to ignore Jeff's insane requirement and
doesn't have to check ATA revision at all.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
