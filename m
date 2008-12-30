Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbYL3XGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbYL3XGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 18:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbYL3XGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 18:06:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48971 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbYL3XGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 18:06:24 -0500
Message-ID: <495AA87D.9060704@kernel.org>
Date: Tue, 30 Dec 2008 15:02:21 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip] fix compilation error
References: <1230648007.10677.1.camel@jaswinder.satnam> <20081230205230.GA6151@nowhere>
In-Reply-To: <20081230205230.GA6151@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Dec 30, 2008 at 08:10:07PM +0530, Jaswinder Singh Rajput wrote:
>> Impact: cleanup, avoid compilation error
>>
>> fixes this compilation error:
>>   CC      mm/slab.o
>> mm/slab.c:105:29: error: linux/kmemtrace.h: No such file or directory
>> make[1]: *** [mm/slab.o] Error 1
>> make: *** [mm] Error 2
>>
>> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> 
> Oops, looks like I've forgot this one.
> Thanks.
> 

Applied to tip:tracing/kmemtrace2.

	-hpa
