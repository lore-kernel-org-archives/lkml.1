Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbZAWPQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbZAWPQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbZAWPQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:16:29 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:51995 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbZAWPQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:16:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=N2vJjQtk72oSsKhvX7vZkEPY1oeyxmyVzc/YaEBWhp0i/3TL3n/Y78zYixi6Dy72p1
         NtBSgB8uvXzXVAL57sr031KvUrZHl2+YuSBveMR2rFLWxuyUJooLsM0E2SUq5rzykoeq
         NsuFGqoDd20/tZmrWEgaxRDIYGKZxvlxFWXp8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0901230955470.13690@qirst.com>
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI>
	 <200901231952.53961.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0901230955470.13690@qirst.com>
Date: Fri, 23 Jan 2009 17:16:25 +0200
X-Google-Sender-Auth: d4f4dd597ef4c047
Message-ID: <84144f020901230716n3f106034x8a10463b411c9a9b@mail.gmail.com>
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 5:03 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> It seems that we currently need the slab allocators to compensate for the
> performance problems in the page allocator for these higher order allocs.
> I'd rather have the page allocator fixed but things are as they are.

So, is that an ACK or a NAK for the patch?-)
