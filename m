Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbXEUG2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbXEUG2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 02:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbXEUG2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 02:28:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50336 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbXEUG23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 02:28:29 -0400
Date: Mon, 21 May 2007 15:28:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: clameter@sgi.com, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-Id: <20070521152830.a844d7ef.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <617E1C2C70743745A92448908E030B2A017BCA67@scsmsx411.amr.corp.intel.com>
References: <Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com>
	<617E1C2C70743745A92448908E030B2A017BCA67@scsmsx411.amr.corp.intel.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 13:37:09 -0700
"Luck, Tony" <tony.luck@intel.com> wrote:

> > I wonder if there are other uses for the free space?
> 
> 	unsigned long moreflags;
> 
> Nick and Hugh were just sparring over adding a couple (or perhaps 8)
> flag bits.  This would supply 64 new bits ... maybe that would keep
> them happy for a few more years.
> 
- page->zone 
  free some flags bits and makes page_zone() simple.
  and software (fake) zone for memory control can be added ?
or 

-page->some_memory_controler ?
(I don't know whether resource controller people want this or not.)

-Kame

