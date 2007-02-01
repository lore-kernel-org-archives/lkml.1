Return-Path: <linux-kernel-owner+w=401wt.eu-S1161121AbXBAAnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161121AbXBAAnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030511AbXBAAnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:43:35 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33662 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030509AbXBAAne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:43:34 -0500
Date: Wed, 31 Jan 2007 16:39:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@osdl.org>
cc: =?ISO-8859-1?Q?Pawe=C5_Sikora?= <pluto@agmk.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Martin Peschke <mp3@de.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Linux 2.6.20-rc7
In-Reply-To: <20070131162631.4ae5800d.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0701311635050.3632@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
 <45C05150.6000802@agmk.net> <Pine.LNX.4.64.0701310748450.3632@woody.linux-foundation.org>
 <200702010037.48472.pluto@agmk.net> <Pine.LNX.4.64.0701311609210.3632@woody.linux-foundation.org>
 <20070131162631.4ae5800d.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Jan 2007, Andrew Morton wrote:
> 
> It would be cleaner to check for negativity, but note that we keep
> subtracting stuff from free_pages in the later loop, so we'd need to check
> there as well.

Yeah, not worth it. I'll just revert it.

If we really want to do the micro-optimization that Nick was after, we can 
just do

	// 'min' is always positive
	min = (unsigned long) min >> 1;

or something.

		Linus
