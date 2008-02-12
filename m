Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbYBLGZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbYBLGZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757896AbYBLGY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:24:59 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38449 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbYBLGY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:24:58 -0500
Message-ID: <47B13B7A.3020003@cs.helsinki.fi>
Date: Tue, 12 Feb 2008 08:23:54 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       blaisorblade@yahoo.it, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slob: fix linking for user mode linux
References: <Pine.LNX.4.64.0802120032160.27876@sbz-30.cs.Helsinki.FI> <1202769569.12383.49.camel@cinder.waste.org> <Pine.LNX.4.64.0802111443130.28253@schroedinger.engr.sgi.com> <20080211233224.GA11432@c2.user-mode-linux.org>
In-Reply-To: <20080211233224.GA11432@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
>> UML defined its own external __kmalloc and things. Isnt there some other 
>> way to fix it? I guess including slab.h is not possible here?
 >
> It would be an annoyance to reintroduce um_kmalloc, but that might be
> the best thing to do here.

I'm ok with that as long as we get this annoying bug fixed.
