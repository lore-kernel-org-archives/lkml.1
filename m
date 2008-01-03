Return-Path: <linux-kernel-owner+w=401wt.eu-S1760226AbYACBOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226AbYACBOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 20:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbYACBN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 20:13:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40307 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbYACBNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 20:13:55 -0500
Message-ID: <477C36CD.5080708@zytor.com>
Date: Wed, 02 Jan 2008 17:13:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jonathan Lim <jlim@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jlan@sgi.com
Subject: Re: [PATCH] Provide u64 version of jiffies_to_usecs() in kernel/tsacct.c
References: <200801030106.m03162PL052329@sabah.engr.sgi.com>
In-Reply-To: <200801030106.m03162PL052329@sabah.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Lim wrote:
> 
> Peter,
> 
> Would you be willing to include the u64 function as part of your patch to make
> it available kernel-wide?  It just needs:
> 
>   u64 inline jiffies_to_usecs_u64(const u64 j)
> 
> and for the symbol to be exported.  Thanks.
> 

It should be a separate patch (new functionality versus change of 
implementation); I'd just do a small patch on top of mine.

	-hpa
