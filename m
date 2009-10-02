Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbZJBUMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbZJBUMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757687AbZJBUMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:12:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58529 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653AbZJBUMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:12:05 -0400
Date: Fri, 2 Oct 2009 22:12:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] x86: Use __builtin_memset and __builtin_memcpy for memset/memcpy
Message-ID: <20091002201208.GO1656@one.firstfloor.org>
References: <20090928113433.5e9b8ea7@infradead.org> <87bpkpbo3t.fsf@basil.nowhere.org> <4AC65CC9.4000105@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC65CC9.4000105@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 01:04:25PM -0700, H. Peter Anvin wrote:
> On 10/02/2009 12:19 PM, Andi Kleen wrote:
> > 
> > I tried this some time ago, but it it generates bad code on some 
> > gcc 3 versions.
> > 
> > You really need to test such kind of changes on a wide variety
> > of compilers, not assuming everyone uses the same version as you.
> > 
> 
> The version that went in is for gcc 4 only.

Thanks.

My memory might be faulty, but iirc 4.0/4.1 was also slightly 
problematic. So better take a look at code for that too
if you haven't yet (just code size numbers are not enough)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
