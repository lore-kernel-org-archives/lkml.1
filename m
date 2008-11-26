Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbYKZUwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbYKZUwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 15:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYKZUv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 15:51:57 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:46478 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbYKZUv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 15:51:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CYwvR3U8ZKbVC4QR3/gwYcxQvdc2+nez+4YZvFpcT/0vktrIrDXvSO/I3bnVyKavPF
         1XwCuW/ZNYZQDWrfCmlbF2bhr6gTkTw4QnBmdovDv+W33P2kyd6fkhxwF4GHS1A+OOc3
         kQ8RuHxB/Xa7qo6KehHGepf7MkmLkQrkbuzLc=
Subject: Re: [PATCH-mm 3/7] unaligned: use generic implementation on
 packed-struct arches
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, will.newton@gmail.com,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20081126124031.c709d597.akpm@linux-foundation.org>
References: <1226979551.6150.268.camel@brick>
	 <20081126124031.c709d597.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 12:51:54 -0800
Message-Id: <1227732714.5511.92.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-26 at 12:40 -0800, Andrew Morton wrote:
> On Mon, 17 Nov 2008 19:39:11 -0800
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > No functional changes, convert arches that use the packed-struct
> > implementation for native-endianness and C byteshifting for the
> > other endianness.
> 
> arch/sh has gone and changed things in linux-next.

Yes, please drop the SH portions of my patch in -mm (your inbox should
already have such a patch)

I also followed up with a new patch to deal with the SH changes and
then a revised patch to deal with some fallout in
asm-generic/unaligned.h

Hopefully this is agreable to everyone.

> so I'll just drop the sh hunk from
> unaligned-use-generic-implementation-on-packed-struct-arches.patch, I
> think.
> 

Please do and add my revised patch and the sh-specific patch.

Cheers,

Harvey

