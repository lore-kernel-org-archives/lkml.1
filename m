Return-Path: <linux-kernel-owner+w=401wt.eu-S934188AbXGKWh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934188AbXGKWh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757079AbXGKWhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:37:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:63702 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbXGKWhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ESgPZLMyHayP0Ufv+Bp5XsLgHOzQwG9472QIWhMuGiMvciFUbr7FyfOUz2xo70myARkR6xpSCdpJSOj8BFPSlnCf6qUpN8t6cpPzvjdOUQZrInr42/mP0NQyDFTZuRrSer0ysgw77tRDsr9BKKsr5aKxAUs65LK8zgPKGHwizxw=
Message-ID: <eada2a070707111537p20ab429anebd8b1840f5e5b5f@mail.gmail.com>
Date: Wed, 11 Jul 2007 15:37:17 -0700
From: "Tim Pepper" <lnxninja@us.ibm.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [RFT][PATCH] mm: drop behind
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Fengguang Wu" <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <1184007008.1913.45.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184007008.1913.45.camel@twins>
X-Google-Sender-Auth: f6ff9d574333139d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/07, Peter Zijlstra <peterz@infradead.org> wrote:
> Use the read-ahead code to provide hints to page reclaim.
>
> This patch has the potential to solve the streaming-IO trashes my
> desktop problem.
>
> It tries to aggressively reclaim pages that were loaded in a strong
> sequential pattern and have been consumed. Thereby limiting the damage
> to the current resident set.

Interesting...

Would it make sense to tie this into (finally) making
POSIX_FADV_NOREUSE something more than a noop?


Tim
