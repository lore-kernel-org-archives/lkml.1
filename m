Return-Path: <linux-kernel-owner+w=401wt.eu-S932320AbZBEB0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbZBEB0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbZBEB0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:26:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46705 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbZBEB0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:26:22 -0500
Message-ID: <498A402E.3030600@zytor.com>
Date: Wed, 04 Feb 2009 17:26:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: uaccess: use errret as error value in __put_user_size()
References: <4983B48E.3070605@ct.jp.nec.com>
In-Reply-To: <4983B48E.3070605@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: cleanup
> 
> In __put_user_size() macro errret is used for error value.
> But if size is 8, errret isn't passed to__put_user_asm_u64().
> This behavior is inconsistent.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Applied to tip:x86/uaccess, thanks!

	-hpa
