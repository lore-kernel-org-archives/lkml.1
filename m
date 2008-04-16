Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbYDPAdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbYDPAdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYDPAdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:33:46 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:16104 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbYDPAdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:33:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TWaj1wvdZ7Di6hej+cJZ+qWH5KWbaNVc2KoYKkn1XPzvulEKUH3WKaot/gp6F6mwPLndEeMjidcm8O19FkPsHAElUNSbiMvoHvBg0/xQPNBsZXqBuon450nfJVQScaBdwbxDNhRaY2KYKL2Ah2pRmjHxmeIkX8nlj5HO5f1d7s0=
Message-ID: <86802c440804151733h414209fcvf38e83fb5c5ec15d@mail.gmail.com>
Date: Tue, 15 Apr 2008 17:33:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       "Mel Gorman" <mel@csn.ul.ie>, "Nick Piggin" <npiggin@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, apw@shadowen.org,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0804151718140.5705@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
	 <20080415195430.GA23015@elte.hu>
	 <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
	 <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi>
	 <20080415204025.GA29784@elte.hu>
	 <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
	 <20080416000356.GA24737@elte.hu>
	 <Pine.LNX.4.64.0804151718140.5705@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 5:19 PM, Christoph Lameter <clameter@sgi.com> wrote:
> On Wed, 16 Apr 2008, Ingo Molnar wrote:
>
>  > if a !PAE x86 kernel is booted on a 32-bit system with more than
>  > 4GB of RAM, then we call memory_present() with a start/end that
>  > goes outside the scope of MAX_PHYSMEM_BITS.
>
>  Well okay this fixes it but is this the right fix? The arch should not
>  call memory_present() with an invalid pfn.

yes in find_max_pfn...

YH
