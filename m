Return-Path: <linux-kernel-owner+w=401wt.eu-S1759713AbZENOJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713AbZENOJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 10:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbZENOJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 10:09:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55660 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbZENOJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 10:09:38 -0400
Message-ID: <4A0C2614.4010803@zytor.com>
Date: Thu, 14 May 2009 07:09:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Extend test_and_set_bit() test_and_clean_bit() to
 64 bits in X86_64
References: <1242202647-32446-1-git-send-email-sheng@linux.intel.com> <4A0AFB7D.2080105@zytor.com> <4A0B036B.7000107@zytor.com> <200905141152.29378.sheng@linux.intel.com>
In-Reply-To: <200905141152.29378.sheng@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sheng Yang wrote:
> 
> Yeah, this one also works well(lightly tested). :)
> 
> But one thing should be noticed that, bit ops recognized the input as signed. 
> According to SDM 2A 3.1.1.7 Operation Section, Bit(BitBase, BitOffset) can 
> accept BitOffset as negative value, then search backward... Well, I indeed 
> don't know when we need this, but I think keep signed here should be better...
> 

Urk, you're right.  How daft.  I had preferred to switch it to unsigned
long to match MIPS and SPARC, but that probably is a good reason to
leave it signed.  Pain.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

