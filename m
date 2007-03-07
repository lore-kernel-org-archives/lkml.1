Return-Path: <linux-kernel-owner+w=401wt.eu-S2992544AbXCGUii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992544AbXCGUii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992545AbXCGUii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:38:38 -0500
Received: from mail.queued.net ([207.210.101.209]:1237 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992544AbXCGUih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:38:37 -0500
Message-ID: <45EF22CF.9030205@debian.org>
Date: Wed, 07 Mar 2007 15:38:39 -0500
From: Andres Salomon <dilinger@debian.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: don't use ZONE_DMA unless CONFIG_ZONE_DMA is set
 in setup.c
References: <45EDFEDB.3000507@debian.org> <20070306175246.b1253ec3.akpm@linux-foundation.org> <20070307040248.GA30278@redhat.com> <45EE42BC.6030209@debian.org> <Pine.LNX.4.64.0703071224470.24546@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0703071224470.24546@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 6 Mar 2007, Andres Salomon wrote:
> 
>> It would've been nice to see the ZONE_DMA removal patches just #define
>> ZONE_DMA regardless, and include less #ifdefs scattered about; but at
>> this point, I'd just as soon prefer to see a proper way to allocate
>> things based on address constraints (as discussed in
>> http://www.gelato.unsw.edu.au/archives/linux-ia64/0609/19036.html).
> 
> Would you be willing to work on that? I can sent you a bunch of unfinished 
> patches if you have the time.

Sure, I'd be willing to work on it.  Whether or not I have the time is
questionable, but it wouldn't hurt to send them..
