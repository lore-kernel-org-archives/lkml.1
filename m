Return-Path: <linux-kernel-owner+w=401wt.eu-S1759423AbZCBEuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423AbZCBEuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 23:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757591AbZCBEun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 23:50:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47062 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbZCBEum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 23:50:42 -0500
Message-ID: <49AB648B.5090302@zytor.com>
Date: Sun, 01 Mar 2009 20:46:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Arjan van de Ven <arjan@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       mingo@elte.hu, sqazi@google.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain> <20090228173813.6d86c0ef@infradead.org> <49A9E7A3.4050102@zytor.com> <200903020106.51865.nickpiggin@yahoo.com.au>
In-Reply-To: <200903020106.51865.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> 
> I would expect any high performance CPU these days to combine entries
> in the store queue, even for normal store instructions (especially for
> linear memcpy patterns). Isn't this likely to be the case?
> 

Actually, that is often not the case simply because it doesn't buy that
much.  The big win comes when you don't read a whole cache line in from
memory, but that is a property of the cache, not the store queue.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

