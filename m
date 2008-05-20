Return-Path: <linux-kernel-owner+w=401wt.eu-S1757690AbYETBQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbYETBQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 21:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYETBQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 21:16:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60806 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbYETBQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 21:16:42 -0400
Message-ID: <4832266D.5010203@zytor.com>
Date: Mon, 19 May 2008 18:16:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Harvey Harrison <harvey.harrison@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm-generic/int-ll64.h: always provide __{s,u}64
References: <20080519215452.GK17716@cs181133002.pp.htv.fi> <4831F89F.5060106@zytor.com> <1211236048.5915.94.camel@brick> <20080519223232.GB17716@cs181133002.pp.htv.fi> <48321299.80303@zytor.com> <20080520001345.GG17716@cs181133002.pp.htv.fi> <4832189B.8000602@zytor.com> <20080520003315.GH17716@cs181133002.pp.htv.fi>
In-Reply-To: <20080520003315.GH17716@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>>>
>> This is a valid point.  This should be __i486__ for userspace, which is  
>> gcc's way to tell you if you're compiling with -march=i486.
> 
> This doesn't help if you're compiling with e.g. -march=pentium
> 

Yes, it does.  -march=pentium defines __i486__ as well as __i586__, and 
so on.

	-hpa
