Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbZAWIx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbZAWIx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 03:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZAWIxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 03:53:18 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:35542 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753262AbZAWIxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 03:53:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=X1KvotWnQHE21SWCsT3HnTAwBV83nitTGvymIeEC0PUGl8p9UeEXR7HA/2oHBRlASQU5JQdoH8HeS84BGHKD2OEipTct/QElz5U9eD7uE9lpkqlsqwGqAY2DEKItXdbS+PTEleZ+lSP+mIKNbs7OwVWTjjUKlvXJG9Z3GJvz1fY=  ;
X-YMail-OSG: PuIlFEMVM1nb2ZH.w_kgq41Vw32Neg_Iar2jLRbRZL5LYs5I28r_3bXKUtPS9CpKaYmaz_9NZmBFwnCOaD0jLU.BrqL7RNg3DhWrNDuGOvOT4kYnwjipbBfamse.pL1nJSsIDiV5UqpMBRv0dW1BNdlus96KKpMaYz3HEev5CkGD.5gLmJnpKgwjJAwfei1MkeTyp2VVuvbuTdHKubukK_7BfEgnTzkA
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
Date: Fri, 23 Jan 2009 19:52:53 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: cl@linux-foundation.org, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901231952.53961.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 January 2009 19:43:20 Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
>
> This patch reverts page allocator pass-through logic from the SLUB
> allocator.
>
> Commit aadb4bc4a1f9108c1d0fbd121827c936c2ed4217 ("SLUB: direct pass through
> of page size or higher kmalloc requests")

Hmm, it lists quite a number of advantages that I guess are being
reverted too? What was the test case(s) that prompted this commit
in the first place? Better ensure it doesn't slow down...

