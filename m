Return-Path: <linux-kernel-owner+w=401wt.eu-S1763314AbXEXDVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763314AbXEXDVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 23:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758238AbXEXDVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 23:21:47 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758958AbXEXDVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 23:21:47 -0400
Date: Wed, 23 May 2007 20:20:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Olivier Galibert <galibert@pobox.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-Reply-To: <alpine.LFD.0.98.0705232016350.3890@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0705232018380.3890@woody.linux-foundation.org>
References: <4635510D.4060103@shaw.ca> <200705231555.07683.jbarnes@virtuousgeek.org>
 <alpine.LFD.0.98.0705231709220.3890@woody.linux-foundation.org>
 <200705231959.26963.jbarnes@virtuousgeek.org>
 <alpine.LFD.0.98.0705232016350.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 May 2007, Linus Torvalds wrote:
> 
> Sure. I think mmconfig is perfectly sane if it falls back to conf1 
> accesses for legacy stuff..

.. but without a regression, it's obviously a post-2.6.22 thing, I guess I 
should make that clear, just because I think people send me patches after 
-rc1 way too eagerly just because they think it fixes a bug.

Basically if it's not somethign that has _ever_ worked some way, it's not 
a bug, it's a feature ;)

			Linus
