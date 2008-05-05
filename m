Return-Path: <linux-kernel-owner+w=401wt.eu-S1760715AbYEEW6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715AbYEEW6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYEEW6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:58:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:63940 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYEEW6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=cwcpefyayroeJmOmtLUZEocFSXzpgMJulUXysVRkcqeppCC0ZFqLixS7r1TC6eMddlPkWPAXsT1pZyjuvlOSt4e1VoCJsSotNdEg4SnkPQrwgMwAc1EjJrc8QbA5QPQTMApgGXIZxbv9sEFbhJMSPJHrORE+yFvmu+jkSP6XKuE=
Message-ID: <2f11576a0805051558j19949eb7ma7e78d9c8ce6917a@mail.gmail.com>
Date: Tue, 6 May 2008 07:58:32 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, bunk@kernel.org
Subject: Re: [2.6 patch] mm/page_alloc.c: cleanups
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
In-Reply-To: <20080505141352.703dbee8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080505182542.GS17139@cs181133002.pp.htv.fi>
	 <2f11576a0805051324r46d3ab03ybf14a289d9841cb6@mail.gmail.com>
	 <20080505134509.2c8a9b94.akpm@linux-foundation.org>
	 <2f11576a0805051359g7614f5f1l9d184539c715fff4@mail.gmail.com>
	 <20080505141352.703dbee8.akpm@linux-foundation.org>
X-Google-Sender-Auth: d807ba12efd2af9b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > >  that's a bug, surely?  I bet there are plenty of places which should be
>  > >  using this hint.
>  >
>  > Hm, as far as I investigate
>  >
>  > 1. nobody used free_cold_page() in kernel code tree.
>  > 2. free_cold_page() doesn't exported.
>  >
>  > I investigated to 2.6.25-mm1.
>  > I don't understand yet why you think plenty....
>
>  Any place in the kernel which frees a page which is probably cache-cold
>  should be using this function.  (Including any place which caused the page
>  to be evicted from CPU cache by placing it under DMA).

Ah, Agreed.

Adrian, Can you remove free_cold_page() change in your patch?
