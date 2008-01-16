Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbYAPW2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbYAPW2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYAPWQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:16:20 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48210 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbYAPWQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:16:19 -0500
Date: Wed, 16 Jan 2008 15:16:18 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: SLUB: Increasing partial pages
Message-ID: <20080116221618.GB11559@parisc-linux.org>
References: <20080116195949.GO18741@parisc-linux.org> <Pine.LNX.4.64.0801161219050.9694@schroedinger.engr.sgi.com> <20080116214127.GA11559@parisc-linux.org> <Pine.LNX.4.64.0801161347160.11353@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801161347160.11353@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 02:01:08PM -0800, Christoph Lameter wrote:
> On Wed, 16 Jan 2008, Matthew Wilcox wrote:
> > I sent you a mail on December 6th ... here are the contents of that
> > mail:
> 
> Dec 6th? I was on vacation then and it seems that I was unable to 
> reproduce the oopses. Can I get some backtraces or other information 
> that would allow me to diagnose the problem?

I'll ask to see what they have.

> > Applying just patches 1-7 and 9 leads to a slight (0.34%) performance
> > reduction compared to slub.  That is 6.45% versus slab, reduces to 6.79%
> > with the 8 patches applied.
> 
> Patch 8 is the one that optimizes the fastpath. How much runtime 
> variability have these tests?

About 0.1-0.2%  0.3% is considered significant.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
