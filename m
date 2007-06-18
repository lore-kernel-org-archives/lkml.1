Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbXFRDDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbXFRDDH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 23:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbXFRDCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 23:02:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41966 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbXFRDCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 23:02:54 -0400
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
	Blocksize support
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <Pine.LNX.4.64.0706171907360.26680@schroedinger.engr.sgi.com>
References: <20070614193839.878721298@sgi.com>
	 <20070614130645.cabdff1b.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
	 <20070614143248.736312f8.akpm@linux-foundation.org>
	 <1182043500.2743.7.camel@laptopd505.fenrus.org>
	 <20070617050255.GM11166@waste.org>
	 <Pine.LNX.4.64.0706171907360.26680@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 17 Jun 2007 20:00:02 -0700
Message-Id: <1182135603.22999.15.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-17 at 19:08 -0700, Christoph Lameter wrote:
> On Sun, 17 Jun 2007, Matt Mackall wrote:
> 
> > Is it? Last I looked it had reverted to handing out reverse-contiguous
> > pages.
> 
> I thought that was fixed? Bill Irwin was working on it.
> 
> But the contiguous pages usually only work shortly after boot. After 
> awhile memory gets sufficiently scrambled that the coalescing in the I/O 
> layer becomes ineffective.

the buddy allocator at least defragments itself somewhat (granted, it's
not perfect and the per cpu page queues spoil the game too...)

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

