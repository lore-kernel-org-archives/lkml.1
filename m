Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbXFZIPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbXFZIPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXFZIO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:14:59 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:50052 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXFZIO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:14:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K10KGL4K2vOaSfVcnStkIh05z2AuLauQfcclSKTockKFT38Ok5JNCr+kqqij9uF+PNzRHwn71KAZ6bsy8l2TrCiKax0YVTNYEXzW8VLMgZVRsr/TF6mtgzggFAD4puQVqYEZcywz4oj0h1QnCRpJiWqy9c09ytOvgYeDsdcErYk=
Message-ID: <b6fcc0a0706260114o59b489a7o7dd7e4ce2e621852@mail.gmail.com>
Date: Tue, 26 Jun 2007 12:14:58 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: gshan <gshan@alcatel-lucent.com>
Subject: Re: bugs in __schedule()
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4680C6F3.9000504@alcatel-lucent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4680C6F3.9000504@alcatel-lucent.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, gshan <gshan@alcatel-lucent.com> wrote:
> Anybody has suggestions on this crash?

talk to whoever supplied the following into your kernel:

> [c02dc4dc] __schedule+0x654/0x788
>  [c02dc6f4] schedule+0x4c/0xe4
>  [c02dbe24] __compat_down+0xc8/0x12c
>  [c0226b60] mv_sw_read_reg+0x178/0x17c

this

>  [c02296fc] mvSwIntrTasklet+0x128/0x744

and this.

>  [c0020afc] tasklet_action+0x7c/0xec
>  [c00204f4] ___do_softirq+0x80/0x11c
>  [c00205cc] __do_softirq+0x3c/0x6c
>  [c00206a4] do_softirq+0x60/0x68
>  [c00207a8] irq_exit+0x6c/0x94
>  [c0005e1c] do_IRQ+0x88/0xa4
>  [c0004b70] ret_from_except+0x0/0x18
>  [c000680c] __delay+0xc/0x14
>  [c0226598] mv_sw_read_smi_reg+0x84/0x1ac
