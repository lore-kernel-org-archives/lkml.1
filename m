Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbYLSUIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbYLSUIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbYLSUIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:08:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:30918 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYLSUIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:08:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=EjT4p8qkeZmPTkPSwtexmI4bstpuD6NamLT82HPT3IvQMfnr/NlWc6a7NIB1BU8uwD
         2c8J0kjclOtsxLIXjFjwjSFrBAU+kipw4j7od54L/ERMgP30OOLcXmd5Zmjca22co3kT
         SbCKnJU+aoqtU00bRajSyXKOKymoj9yeEOxqw=
Message-ID: <84144f020812191208x66f26bc9tf087b35b6c90662a@mail.gmail.com>
Date: Fri, 19 Dec 2008 22:08:34 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Subject: Re: [PATCH 01/14] kmemleak: Add the base support
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20081219181302.7778.15966.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	 <20081219181302.7778.15966.stgit@pc1117.cambridge.arm.com>
X-Google-Sender-Auth: 3c556a55530bbab9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 8:13 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> This patch adds the base support for the kernel memory leak
> detector. It traces the memory allocation/freeing in a way similar to
> the Boehm's conservative garbage collector, the difference being that
> the unreferenced objects are not freed but only shown in
> /sys/kernel/debug/kmemleak. Enabling this feature introduces an
> overhead to memory allocations.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Looks good to me. I have only reviewed this lightly but all my major
concerns have been addressed so feel free to add my:

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
