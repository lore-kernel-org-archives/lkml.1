Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbXLZRon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbXLZRon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 12:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXLZRof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 12:44:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40421 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbXLZRoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 12:44:34 -0500
Message-ID: <477292F2.7020404@zytor.com>
Date: Wed, 26 Dec 2007 09:44:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [x86] is checkpatch.pl broken
References: <20071225170737.GA3887@cvg.org> <477196DC.9000704@zytor.com> <aa79d98a0712260238n4848e812l4a66f86b414cc277@mail.gmail.com>
In-Reply-To: <aa79d98a0712260238n4848e812l4a66f86b414cc277@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
>
>>
> It's a quite true, sorry for this and thanks for the note. And Peter,
> the line I marked
> is not to be splitted even having additional spaces over  math operators. Look
> 
> orig:
> mbr_base = (buf_base+sector_size-1) & ~(sector_size-1);
> new (could be):
> mbr_base = (buf_base + sector_size - 1) & ~(sector_size - 1);
> 
> Is a new version that bad?

Certainly isn't any better.

	-hpa
