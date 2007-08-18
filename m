Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbXHRMwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbXHRMwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 08:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbXHRMwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 08:52:05 -0400
Received: from ns2.suse.de ([195.135.220.15]:60703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbXHRMwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 08:52:04 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 6/6] Do not use FASTCALL for __alloc_pages_nodemask()
Date: Sat, 18 Aug 2007 14:51:47 +0200
User-Agent: KMail/1.9.6
Cc: Mel Gorman <mel@csn.ul.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20070817201647.14792.2690.sendpatchset@skynet.skynet.ie> <20070817201848.14792.58117.sendpatchset@skynet.skynet.ie> <Pine.LNX.4.64.0708171406520.9635@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708171406520.9635@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708181451.47219.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007 23:07:33 Christoph Lameter wrote:
> On Fri, 17 Aug 2007, Mel Gorman wrote:
> 
> > Opinions as to why FASTCALL breaks on one machine are welcome.
> 
> Could we get rid of FASTCALL? AFAIK the compiler should automatically 
> choose the right calling convention?

It was a nop for some time because register parameters are always enabled
on i386 and AFAIK no other architectures ever used it. Some out of tree
trees some to disable register parameters though, but that's not 
really a concern.

-Andi


