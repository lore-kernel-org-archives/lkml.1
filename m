Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZENOgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZENOgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 10:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZENOgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 10:36:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39499 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZENOgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 10:36:39 -0400
Message-ID: <4A0C2C5F.4030008@zytor.com>
Date: Thu, 14 May 2009 07:36:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Extend test_and_set_bit() test_and_clean_bit() to
 64 bits in X86_64
References: <1242202647-32446-1-git-send-email-sheng@linux.intel.com> <87zldhl7ne.fsf@basil.nowhere.org> <200905141145.05591.sheng@linux.intel.com> <20090514083250.GD19296@one.firstfloor.org> <4A0C262B.3060303@zytor.com> <20090514141649.GD10933@one.firstfloor.org> <4A0C27AA.4010006@zytor.com> <20090514142749.GE10933@one.firstfloor.org> <4A0C29D2.9050101@zytor.com> <20090514143312.GF10933@one.firstfloor.org>
In-Reply-To: <20090514143312.GF10933@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> Well they have to fix a lot of more stuff then, when I did 
> all the inline assembler >2GB objects were a explicit non goal. 
> It also wouldn't surprise me if that wasn't true on other architectures too.

512 MB, fwiw...

> It would be better to just use open coded C for that case and avoid inline 
> assembler.

It's not like the extra REX prefix is going to matter significantly for
any application, and given how trivial it is it doesn't seem like a big
deal at all.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

