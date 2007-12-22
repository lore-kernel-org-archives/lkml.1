Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbXLVNmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbXLVNmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 08:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbXLVNmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 08:42:04 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:61529 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbXLVNmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 08:42:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Q90YiqQB2EFkRKha/Jd4bagTJpmZQgqo33bMunDdVtpJj80ygba4I0K9UBAPqrBZnO3jZbiIXSXNRf4vClKwreTYhM3LOlr3pT6/QyVWLcB1rc0RYH4A9KTXNNcARLBHxzI4bH/AyJ6IRfzUNYgtcPb1CA4RowVGXwMe/dMhJ9o=
Message-ID: <84144f020712220542u6d5f4006pf50ddb0b6d5e5a3f@mail.gmail.com>
Date: Sat, 22 Dec 2007 15:42:01 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] slub: /proc/slabinfo ABI compatibility
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, clameter@sgi.com, a.p.zijlstra@chello.nl
In-Reply-To: <20071222133727.GA12031@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0712221446280.24655@sbz-30.cs.Helsinki.FI>
	 <20071222131601.GB32558@elte.hu> <20071222133727.GA12031@elte.hu>
X-Google-Sender-Auth: dd322758a27d7160
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Dec 22, 2007 3:37 PM, Ingo Molnar <mingo@elte.hu> wrote:
> Pekka, i stuck your patch into the x86.git random-test-grid, and it
> found the following build error after a few iterations:
>
>   mm/slub.c: In function 's_show':
>   mm/slub.c:4188: error: implicit declaration of function 'count_partial'

Looks good. Thanks!

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
