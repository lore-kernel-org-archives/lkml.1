Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbXLZSPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbXLZSPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 13:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXLZSP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 13:15:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:40152 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbXLZSP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 13:15:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hvrnoPmigQ12OZVEsUEaEZEvfYm+8lb9UJKhjOkC47wLW//OuVnijg4EQVQ8ng4lm94+3Cn5fQ1LlyksCDocG6nJ8A+p9pkSmJLrFd1pGpYO8ESGQU82lUAqlM36u/gXT7Pv9V4J556y3pqMrvFtfApfuVJhUTv+hBQgos+5bxk=
Date: Wed, 26 Dec 2007 21:15:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [x86] is checkpatch.pl broken
Message-ID: <20071226181522.GA3892@cvg.org>
References: <20071225170737.GA3887@cvg.org> <477196DC.9000704@zytor.com> <aa79d98a0712260238n4848e812l4a66f86b414cc277@mail.gmail.com> <477292F2.7020404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477292F2.7020404@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Wed, Dec 26, 2007 at 09:44:18AM -0800]
> Cyrill Gorcunov wrote:
>>
>>>
>> It's a quite true, sorry for this and thanks for the note. And Peter,
>> the line I marked
>> is not to be splitted even having additional spaces over  math operators. Look
>>
>> orig:
>> mbr_base = (buf_base+sector_size-1) & ~(sector_size-1);
>> new (could be):
>> mbr_base = (buf_base + sector_size - 1) & ~(sector_size - 1);
>>
>> Is a new version that bad?
>
> Certainly isn't any better.
>
> 	-hpa
>

ok, i'm leaving this section then, thanks for comments Peter.

			- Cyrill -

