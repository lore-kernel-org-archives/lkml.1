Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYJQUzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYJQUzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYJQUzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:55:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061AbYJQUzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:55:03 -0400
Date: Fri, 17 Oct 2008 13:54:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, yhlu.kernel@gmail.com, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
In-Reply-To: <48F8F5F9.1050506@zytor.com>
Message-ID: <alpine.LFD.2.00.0810171348110.3438@nehalem.linux-foundation.org>
References: <adatzbbap8a.fsf@cisco.com> <1224214314.7654.65.camel@pasglop>  <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>  <20081016.210404.151891223.davem@davemloft.net>  <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
 <1224220339.7654.84.camel@pasglop> <alpine.LFD.2.00.0810170852010.3438@nehalem.linux-foundation.org> <48F8F5F9.1050506@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Oct 2008, H. Peter Anvin wrote:
> 
> This reminds me to add support for the ' modifier in the kernel printk...

So if you end up doing that... SUS seems to only specify it for decimal 
numbers, I wonder if it makes sense to extend it to hex too - but group by 
four. Octal? I have no clue, nor do I care.

		Linus
