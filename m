Return-Path: <linux-kernel-owner+w=401wt.eu-S1758338AbXEZLVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbXEZLVZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 07:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXEZLVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 07:21:18 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:38278 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbXEZLVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 07:21:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CzUXKjjzst66lFbkYfE9tCGCn66YdLMPEC7hVcKjPvdWnxQewOW8n5lzTN1dQ13StJQsjhO/czfPkN7pUwo0GPeHYJPzEZ5Y+EbWsZx+LqkbqDMtqtAN6Qopq/hSFtB1cAjI6CiLrJfivmKsYrpUPMa/BtlrHpjYUS2qnEZQ320=
Message-ID: <4cefeab80705260421x2af3d65bi868a1cb37c6bd633@mail.gmail.com>
Date: Sat, 26 May 2007 16:51:17 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Richard Purdie" <richard@openedhand.com>
Subject: Re: [RFC] LZO de/compression support - take 4
Cc: linux-kernel@vger.kernel.org, linux-mm-cc@laptop.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Andrey Panin" <pazke@donpac.ru>, "Bret Towe" <magnade@gmail.com>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>
In-Reply-To: <1180175325.5856.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com>
	 <1180095000.5864.48.camel@localhost.localdomain>
	 <4cefeab80705250557w1baee0afn255e37436b6545a@mail.gmail.com>
	 <1180175325.5856.23.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 5/26/07, Richard Purdie <richard@openedhand.com> wrote:
>
> I've been looking at my benchmark figures and I think I've found why the
> figures for my version were different to yours. Its not your code which
> is at fault, its the way it was hooked into the benchmarking program.
> The compiler was inlining some parts which it shouldn't have been
> allowed to do, sorry :-/.
>
> With that issue corrected, decompression is the same speed however
> compression is showing about a 9% performance loss compared to my kernel
> patch.
>
> I did some diffs of the assembler outputted by our two versions (mine
> matches minilzo). For decompression the output is effectively identical.
> For compression, there are significant differences. If I add a noinline
> attribute to lzo1x_compress_worker, that removes a lot of them (and
> boosts speed a bit) but there are still differences. Ideally, I'd like
> to understand why.
>

I will look more closely into compression code to see why you are
getting this perf. difference here.

Thanks for your tests.

- Nitin
