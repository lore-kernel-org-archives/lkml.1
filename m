Return-Path: <linux-kernel-owner+w=401wt.eu-S934058AbYBHGfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058AbYBHGfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 01:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYBHGe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 01:34:59 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41440 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbYBHGe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 01:34:58 -0500
Message-ID: <47ABF7D5.7040406@cs.helsinki.fi>
Date: Fri, 08 Feb 2008 08:33:57 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH 1/2] kmemcheck v3
References: <47AB79D4.2070605@gmail.com>  <Pine.LNX.4.64.0802071341500.2544@schroedinger.engr.sgi.com> <19f34abd0802071412m569e4993kffb4a3af163fa16c@mail.gmail.com> <Pine.LNX.4.64.0802071443440.3289@schroedinger.engr.sgi.com> <47ABF715.60407@cs.helsinki.fi>
In-Reply-To: <47ABF715.60407@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> No. We need to not track the whole page to avoid recursive faults. So 
> for kmemcheck we absolutely do need cache_cache but we can, of course, 
> hide that under a alloc_cache() function that only uses the extra cache 
> when CONFIG_KMEMCHECK is enabled?

Btw, one option is to have a new _page flag_ so that we no longer need 
to look inside struct kmem_cache in the page fault handler.

			Pekka


