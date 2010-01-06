Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559Ab0AFIm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0AFIm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 03:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500Ab0AFIm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 03:42:58 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48858 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab0AFIm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 03:42:58 -0500
Message-ID: <4B444CF4.50606@cs.helsinki.fi>
Date: Wed, 06 Jan 2010 10:42:28 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Haicheng Li <haicheng.li@linux.intel.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Matt Mackall <mpm@selenic.com>, Andi Kleen <andi@firstfloor.org>,
       Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] slab: initialize unused alien cache entry as NULL
 at 	alloc_alien_cache().
References: <4B443AE3.2080800@linux.intel.com> <84144f021001060020v57535d5bwc65b482eca669bc5@mail.gmail.com> <4B444C39.3020901@linux.intel.com>
In-Reply-To: <4B444C39.3020901@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Haicheng Li wrote:
> Pekka Enberg wrote:
>  > I can find a trace of Andi acking the previous version of this patch
>  > but I don't see an ACK from Christoph nor a revieved-by from Matt. Was
>  > I not CC'd on those emails or what's going on here?
>  >
> 
> Christoph said he will ack this patch if remove the change of 
> MAX_NUMNODES (see below),
> so I add him directly as Acked-by in this revised patch. And also, I got 
> review
> comments from Matt for v1 and changed the patch accordingly.
> 
> Is it a violation of the rule? if so, I'm sorry, actually not quite 
> clear with the rule.

See Section 14 of Documentation/SubmittingPatches. You should never add 
tags unless they came from the said person. The ACKs from Andi is fine, 
the one from Christoph is borderline but OK and the one from Matt is 
_not_ OK.

I can fix those up but I'll wait from an explicit ACK from Christoph first.

                         Pekka
