Return-Path: <linux-kernel-owner+w=401wt.eu-S1764579AbXESSZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764579AbXESSZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759595AbXESSZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:25:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56030 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763036AbXESSZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:25:12 -0400
Date: Sat, 19 May 2007 11:25:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
In-Reply-To: <20070519181501.GC19966@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0705191121480.17008@schroedinger.engr.sgi.com>
References: <20070518040854.GA15654@wotan.suse.de>
 <Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com>
 <20070519012530.GB15569@wotan.suse.de> <20070519181501.GC19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007, William Lee Irwin III wrote:

> However, there are numerous optimizations and features made possible
> with flag bits, which might as could be made cheap by padding struct
> page up to the next highest power of 2 bytes with space for flag bits.

Well the last time I tried to get this by Andi we became a bit concerned 
when we realized that the memory map would grow by 14% in size. Given 
that 4k page size challenged platforms have a huge amount of page structs 
that growth is significant. I think it would be fine to do it for IA64 
with 16k page size but not for x86_64.


