Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbYG3RXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbYG3RXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYG3RXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:23:04 -0400
Received: from il.qumranet.com ([212.179.150.194]:13041 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbYG3RXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:23:03 -0400
Message-ID: <4890A375.4060103@qumranet.com>
Date: Wed, 30 Jul 2008 20:23:01 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Adrian Bunk <bunk@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/2] Export get_user_pages_fast
References: <200807301438.55941.rusty@rustcorp.com.au>	<20080730033523.0f38f7e4.akpm@linux-foundation.org>	<20080730154736.GC21597@cs181140183.pp.htv.fi>	<20080730100355.f1402dcf.akpm@linux-foundation.org>	<20080730170939.GA28604@cs181140183.pp.htv.fi> <20080730101438.e1484440.akpm@linux-foundation.org>
In-Reply-To: <20080730101438.e1484440.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> o other arch 
>> would define CONFIG_HAVE_GET_USER_PAGES_FAST.
>>
>>     
>
> That's presently true in Linus mainline.  The powerpc implementation is
> in -mm, but apprarently needs a bit more work.

Wouldn't a generic get_user_pages_fast() implementation which calls 
get_user_pages_slow() if the arch hadn't implemented the former reduce a 
lot of #ifdefs in call sites?

-- 
error compiling committee.c: too many arguments to function

