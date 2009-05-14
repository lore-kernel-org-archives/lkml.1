Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbZENOZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbZENOZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 10:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbZENOZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 10:25:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36361 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbZENOZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 10:25:38 -0400
Message-ID: <4A0C29D2.9050101@zytor.com>
Date: Thu, 14 May 2009 07:25:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Extend test_and_set_bit() test_and_clean_bit() to
 64 bits in X86_64
References: <1242202647-32446-1-git-send-email-sheng@linux.intel.com> <87zldhl7ne.fsf@basil.nowhere.org> <200905141145.05591.sheng@linux.intel.com> <20090514083250.GD19296@one.firstfloor.org> <4A0C262B.3060303@zytor.com> <20090514141649.GD10933@one.firstfloor.org> <4A0C27AA.4010006@zytor.com> <20090514142749.GE10933@one.firstfloor.org>
In-Reply-To: <20090514142749.GE10933@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> Pretty much all the bit ops and a few other operations currently have
> 2/4GB limits on x86-64. I don't think that's going to change.
> 
> In the kernel nothing is ever that big continuously anyways.
> 

Uhm, that *is* the problem at hand... specifically the bootmem map on
multi-terabyte systems.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

