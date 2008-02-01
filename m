Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbYBADsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbYBADsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 22:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbYBADr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 22:47:56 -0500
Received: from hu-out-0506.google.com ([72.14.214.238]:46025 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbYBADrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 22:47:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mRJekO3w1x3D8YVkbVWsVleO5pUwCXD6Rz5yI+E11iFfu8AEDiC/EYvLvHtQB7/xrKzzRt91qzA10iWhJ8IcCK9NV/uE72S4FS8QGH4Pwq6vz0yoe14f53WKeP6uzZap2A30U9NUF+3553NMHyz1/EG3lmMmVjRoCT6oRuhNfDQ=
Date: Fri, 1 Feb 2008 11:45:15 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch] include/asm-generic/tlb.h: fix a missing header
Message-ID: <20080201034514.GA2478@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080131145900.GB2471@hacking> <Pine.LNX.4.64.0801311407530.1253@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801311407530.1253@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 02:08:31PM -0800, Christoph Lameter wrote:
>On Thu, 31 Jan 2008, WANG Cong wrote:
>
>> index 6ce9f3a..4ebbe15 100644
>> --- a/include/asm-generic/tlb.h
>> +++ b/include/asm-generic/tlb.h
>> @@ -16,6 +16,7 @@
>>  #include <linux/swap.h>
>>  #include <linux/quicklist.h>
>>  #include <asm/tlbflush.h>
>> +#include <asm/pgalloc.h>
>
>Please also remove the #include <linux/quicklist.h>. It should have been 
>part of 
>a patch 
>reversal.

Please ignore this patch, since Ingo already had the same one.

Thanks!

