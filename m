Return-Path: <linux-kernel-owner+w=401wt.eu-S1765796AbYEAW6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765796AbYEAW6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760978AbYEAW6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:58:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52577 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507AbYEAW6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:58:06 -0400
Message-ID: <481A4ACA.10008@zytor.com>
Date: Thu, 01 May 2008 15:57:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 - auto detect v2
References: <200804272337.40130.yhlu.kernel@gmail.com>	 <481A1D3A.5040202@zytor.com>	 <86802c440805011402h1e452b57ma27ffa6ad7b50238@mail.gmail.com>	 <481A31E2.2020800@zytor.com>	 <86802c440805011420g78a6abberaae6b765663ed33b@mail.gmail.com>	 <481A356C.5090502@zytor.com>	 <86802c440805011431i88dec8aiadcb143b5f7648b@mail.gmail.com>	 <481A372C.5080808@zytor.com>	 <86802c440805011444i56611b1ave44a714da7988fa@mail.gmail.com>	 <481A3AD6.1040905@zytor.com> <86802c440805011552t213b9badv926baeb0b4bc5227@mail.gmail.com>
In-Reply-To: <86802c440805011552t213b9badv926baeb0b4bc5227@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> only search 78
> 2g, 1g, ...1m, and half matrix 13 * 6..
> 
> and don't need to search than 78.
> 

Again, it's not clear to me why there is an inherent limit at 2 GB.

	-hpa
