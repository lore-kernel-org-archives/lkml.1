Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbYDJWQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbYDJWQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYDJWP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:15:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45176 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbYDJWP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:15:59 -0400
Message-ID: <47FE9158.6060404@zytor.com>
Date: Thu, 10 Apr 2008 15:14:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader
 decompressor -- payload_length
References: <86802c440804101334j4b69373dv172ab72b072dc4a0@mail.gmail.com>	 <47FE7A6C.1070405@zytor.com>	 <86802c440804101415o55af93c8o8f4dc54dfad8662e@mail.gmail.com>	 <47FE8AB1.90506@zytor.com> <86802c440804101448n7fe5d04x315a30ba877774f4@mail.gmail.com>
In-Reply-To: <86802c440804101448n7fe5d04x315a30ba877774f4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>>
>>  Sorry, I don't understand.
> 
> where can i find the unzip paload size from payload hdrs?
> 

The size of the unzip payload you get by looking at the last four bytes 
of the gzip payload (after verifying the existence of a gzip magic 
number.)  For more specific details, look at the ELF segment headers.

	-hpa
