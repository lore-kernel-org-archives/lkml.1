Return-Path: <linux-kernel-owner+w=401wt.eu-S1761108AbXEVAjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761108AbXEVAjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbXEVAjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:39:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34203 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755015AbXEVAjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:39:00 -0400
Date: Mon, 21 May 2007 17:38:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: ak@suse.de, dada1@cosmosbay.com, wli@holomorphy.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
In-Reply-To: <20070522093050.0320d092.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0705211737450.24160@schroedinger.engr.sgi.com>
References: <20070518040854.GA15654@wotan.suse.de>
 <Pine.LNX.4.64.0705191121480.17008@schroedinger.engr.sgi.com>
 <464FCA28.9040009@cosmosbay.com> <200705201456.26283.ak@suse.de>
 <Pine.LNX.4.64.0705211006550.26282@schroedinger.engr.sgi.com>
 <20070522093050.0320d092.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007, KAMEZAWA Hiroyuki wrote:

> For i386(32bit arch), there is not enough space for vmemmap.

I thought 32 bit would use flatmem? Is memory really sparse on 32 
bit? Likely difficult due to lack of address space?

> For 64bit arch, page flags are not exhausted yet.

Right.

