Return-Path: <linux-kernel-owner+w=401wt.eu-S1763797AbYBUTxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763797AbYBUTxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbYBUTxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:53:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51354 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbYBUTxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:53:30 -0500
Message-ID: <47BDD698.9000906@zytor.com>
Date: Thu, 21 Feb 2008 11:52:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup - use PAGE_SIZE instead of numeric constant
 in boot code
References: <20080221195022.GA6772@cvg>
In-Reply-To: <20080221195022.GA6772@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> This patch replaces 4096 numeric constant with PAGE_SIZE macro.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> Text segments of old and new files *are* the same so
> it wouldn't break current kernel.
> 

NAK.

This is NOT PAGE_SIZE (even though the two values are coincidentally the 
same, for historical reasons.)

	-hpa
