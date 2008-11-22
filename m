Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbYKVMhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbYKVMhz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 07:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757450AbYKVMhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 07:37:46 -0500
Received: from po-out-1718.google.com ([72.14.252.152]:48766 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195AbYKVMhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 07:37:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VYXA7AU+SRYooFWl6W+P6JDfmhFNcrS2j2GDqu6cqEccgr4yMGtSCcihIeaB4KA7+Z
         LMjTl1yeP34KubcoSHRXcnmF20YT/dZj372edYTBqU933OhGN4uoTF9MxYn5GgoB6BK1
         Zet13BwlGyp5OedxZktZ7UumZtmOJxf3ASXG4=
Message-ID: <19f34abd0811220437w3e20f824m27578618777ae8b7@mail.gmail.com>
Date: Sat, 22 Nov 2008 13:37:45 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] SLUB: use page allocator for PAGE_SIZE requests
Cc: "Mel Gorman" <mel@csn.ul.ie>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0811220435r38e749e3o425d994912fc92ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081122123230.GA27189@localhost.localdomain>
	 <19f34abd0811220435r38e749e3o425d994912fc92ea@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 1:35 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Sat, Nov 22, 2008 at 1:32 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> From 4d526db4781aaab86cb79ff8135bb0e2bc560598 Mon Sep 17 00:00:00 2001
>> From: Vegard Nossum <vegard.nossum@gmail.com>
>> Date: Sat, 22 Nov 2008 13:27:54 +0100
>> Subject: [PATCH] SLUB: use page allocator for PAGE_SIZE requests
>>
>> It seems strange that we should use the page allocator for
>> requests of (PAGE_SIZE + 1) bytes or more, and not for requests
>> that are exactly PAGE_SIZE.
>
> Actually, there are some more places that need to be fixed. I think
> I'll send an updated patch that fixes all of them.

ACTUALLY, please ignore whole thread. I now read the commit message of

commit 331dc558fa020451ff773973cee855fd721aa88e
Author: Christoph Lameter <clameter@sgi.com>
Date:   Thu Feb 14 14:28:09 2008 -0800

    slub: Support 4k kmallocs again to compensate for page allocator slowness

:-/

Sorry for the noise.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
