Return-Path: <linux-kernel-owner+w=401wt.eu-S1762545AbXESPnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762545AbXESPnc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 11:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759335AbXESPnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 11:43:24 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1523 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759220AbXESPnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 11:43:24 -0400
Message-ID: <464F1B21.8020408@shadowen.org>
Date: Sat, 19 May 2007 16:43:29 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [rfc] increase struct page size?! (now sparsemem vmemmap)
References: <20070518040854.GA15654@wotan.suse.de> <Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com> <20070519012530.GB15569@wotan.suse.de> <Pine.LNX.4.64.0705181901130.14521@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705181901130.14521@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Sat, 19 May 2007, Nick Piggin wrote:
> 
>> Hugh points out that we should make _count and _mapcount atomic_long_t's,
>> which would probably be a better use of the space once your vmemmap goes
>> in.
> 
> Well Andy was going to merge it:
> 
> http://marc.info/?l=linux-kernel&m=117620162415620&w=2
> 
> Andy when are we going to get the vmemmap patches into sparsemem?

Sorry this has been backed up with all the too-ing and fro-ing on other
things.  I am just cleaning up the next round which includes feedback
from wli and first stab at PPC64 support.  Should be out monday for review.

-apw
