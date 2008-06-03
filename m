Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbYFCPxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbYFCPxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 11:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYFCPxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 11:53:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:54409 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYFCPxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 11:53:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EOdi4nIHAMPKqObrzwTJvCfddOQ8lrtIJsySPu6PcdSw8zAo7ARhXgkA1yEdv6yXhs0Aj6WBybT3sWGFPtFLlhmK1DsbZ1pHMcTNTO7LOOD1cjImIAzWY45QdXgLZSwOfgPCUKxRVmM2YYxZe86LPIvQ9+gNcSgz4L3todue7g4=
Message-ID: <19f34abd0806030853p747c01bft7b773b21e1361bcb@mail.gmail.com>
Date: Tue, 3 Jun 2008 17:53:22 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: Re: + x86-implement-pte_special.patch added to -mm tree
Cc: mm-commits@vger.kernel.org, andi@firstfloor.org, apw@shadowen.org,
       jens.axboe@oracle.com, mingo@elte.hu, pbadari@us.ibm.com,
       shaggy@austin.ibm.com, tglx@linutronix.de, zach.brown@oracle.com
In-Reply-To: <200806022356.m52NuRTj006330@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806022356.m52NuRTj006330@imap1.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/08, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
>
>  The patch titled
>      x86: implement pte_special
>  has been added to the -mm tree.  Its filename is
>      x86-implement-pte_special.patch

...

>  ------------------------------------------------------
>  Subject: x86: implement pte_special
>  From: Nick Piggin <npiggin@suse.de>
>
>  Implement the pte_special bit for x86.  This is required to support
>  lockless get_user_pages, because we need to know whether or not we can
>  refcount a particular page given only its pte (and no vma).

Wait... what the heck is a "special" page? Isn't that a terrible name
for _anything_? Or is there a tradition to the name? It sounds like it
should be named "novma" or "autonomous" or something instead.
Something that carries at least a little more information than
"special". Where can I find the documentation for this bit?

Has this been discussed on LKML? Is the name a result of consensus or whim?

Help! :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
