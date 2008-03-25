Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbYCYXAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbYCYXAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757889AbYCYW75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:59:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40929 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbYCYW75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:59:57 -0400
Message-ID: <47E983E3.4050806@zytor.com>
Date: Tue, 25 Mar 2008 15:59:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "J.C. Pizarro" <jcpiza@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: What means Hugepage? 8KiB,16KiB,..,2MiB or 4MiB?
References: <998d0e4a0803251503v7bf20ad4ndb0e21b1eead7f9d@mail.gmail.com>
In-Reply-To: <998d0e4a0803251503v7bf20ad4ndb0e21b1eead7f9d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.C. Pizarro wrote:
> What means Hugepage?
> 
> Does it mean 8KiB? 16KiB? 32KiB? 64KiB? 2MiB? 4MiB?
> 
> The real page sizes of x86 and x86-64 are 4 KiB for this linux kernel.
> 
> But the page sizes can be soft 8 KiB or 16 KiB or 32 KiB or 64 KiB
> if it is implemented in the memory manager of the kernel.
> 
> But too they exist real page sizes of 2 MiB and 4 MiB that they have
> some reserved entries of TLB in the specs of Intel/AMD processors
> for these gigant pages.

On x86, it means 2/4 MiB, or even 1 GiB in some very strange 
circumstances.  Other architectures might be different.

	-hpa
