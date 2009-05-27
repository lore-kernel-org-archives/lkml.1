Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZE0CMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZE0CMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbZE0CL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:11:57 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:37723 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842AbZE0CL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:11:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lyc7nFjiS2STHZhjgAlXUG5HnfyWNAac2JakyJckBYkB5vPpvzk+jZRcUNIgCLp3Cr
         HqKqrPDNQfnwwZoIuyCCErgxwbltj4mXtN2wfYXHg9rxbMA36WvHpLsz2wUP7C0mt41Q
         DwGxpk2drXQVdni8oANX1P4ifFj8t64orXqtE=
MIME-Version: 1.0
In-Reply-To: <4A1C7DDB.9010605@gmail.com>
References: <64bb37e0905261214g2957924ar837339367f320d4c@mail.gmail.com>
	 <4A1C7DDB.9010605@gmail.com>
Date: Wed, 27 May 2009 04:11:56 +0200
Message-ID: <64bb37e0905261911v1b80456ckbc7b7c7858d4b28a@mail.gmail.com>
Subject: Re: sata_sil24 0000:04:00.0: DMA-API: device driver frees DMA sg list 
	with different entry count [map count=13] [unmap count=10]
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 1:40 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> Torsten Kaiser wrote:
>>
>> On upgrading to 2.6.30-rc1 I enable the DMA-Debugging option
>> CONFIG_DMA_API_DEBUG=y
>> Since then I get the following or similar errors on each boot:
>
> Please retest with a newer -rc, this patch likely fixes it:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5825627c9463581fd9e70f8285685889ae5bb9bb
>

I saw this with 2.6.30-rc1 the first time, but I'm not sure if it
broke during the merge window or if it was always broken, because I
did not have enable DMA_API_DEBUG with earlier kernels.

But I'm seeing it with all -rc since then. The traces I posted were
from -rc6 and -rc7.

Torsten
