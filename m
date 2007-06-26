Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbXFZISQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbXFZISQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbXFZISF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:18:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:58266 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXFZISD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:18:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k1hsqH2g/gTiw2vqW5Ax7FzVNNm5fJnF8QH2dH5lkhv6fIJd5A4ZAE20Oi20nh9PUGimlvaoaBEnk8HdfO/pzVPdzvY9azhYTPdCitg4obpI8Mg4qEGdFcP+73MtCXikZXq/ir3gcEtyNIj+t1W6zHA3wqhJEi/pf1+Uyb8LfnE=
Message-ID: <a781481a0706260118o2ef795bj579b3ec86c4fca8a@mail.gmail.com>
Date: Tue, 26 Jun 2007 13:48:02 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
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

Hi Gavin,

On 6/26/07, gshan <gshan@alcatel-lucent.com> wrote:
> Anybody has suggestions on this crash?
>
> [c02dc4dc] __schedule+0x654/0x788
>  [c02dc6f4] schedule+0x4c/0xe4
>  [c02dbe24] __compat_down+0xc8/0x12c
>  [c0226b60] mv_sw_read_reg+0x178/0x17c
>  [c02296fc] mvSwIntrTasklet+0x128/0x744
>  [c0020afc] tasklet_action+0x7c/0xec
>  [c00204f4] ___do_softirq+0x80/0x11c
>  [c00205cc] __do_softirq+0x3c/0x6c
>  [c00206a4] do_softirq+0x60/0x68
>  [c00207a8] irq_exit+0x6c/0x94
>  [c0005e1c] do_IRQ+0x88/0xa4
>  [c0004b70] ret_from_except+0x0/0x18
>  [c000680c] __delay+0xc/0x14
>  [c0226598] mv_sw_read_smi_reg+0x84/0x1ac

I bet you got more output than that, didn't you? :-)

Now I know this must be a "scheduling while interrupts disabled",
but why not post the whole error message?

[ Reminds me of the other thread where someone thought just mentioning
the EIP without any backtrace / other messages was enough to resolve a
boot-time panic. I agree they're all magicians on this list, but Gods they're
not ... ]

BTW I don't see "mvSwIntrTasklet" anywhere on -rc6. Is this a -mm kernel?

Cheers,
Satyam
