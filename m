Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYHDSTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYHDSTC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbYHDSSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:18:12 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:42383 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbYHDSNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:13:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Iqbrj7oC0hJXIne7QNBWObZ5Q4x2AtPq3nVBQElFNCmZreHsJGcFMOjyyLmOnTPZOE
         27mxlHmcHY8BRDTAECY4JHnIXTDU7JO4goGuEZ7rMkVIXexxEuVtSxhkFlE1rfOXp48p
         GHcddBrEDjQe/8LT7RLVlxtqu9xifeYzAKnn0=
Message-ID: <86802c440808041113i77ad39b6of5b84e36e6bed830@mail.gmail.com>
Date: Mon, 4 Aug 2008 11:13:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 21/25] serial: change remove NR_IRQS in 8250.c v2
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080804151734.0d82fbe9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-17-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-18-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-19-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-20-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-21-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-22-git-send-email-yhlu.kernel@gmail.com>
	 <20080803161447.791705bb@lxorguk.ukuu.org.uk>
	 <m1hca150t8.fsf@frodo.ebiederm.org>
	 <20080804151734.0d82fbe9@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2008 at 7:17 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Would allow us to use the generic hash table code.
>
> Nice.. that makes the code a bit longer in source form but much clearer
> and sharing common design.
>
>> Looks like we can also tweak serial_do_unlink to free irq_info when
>> the list goes empty, so we don't have a leak if the driver is ever
>> unloaded.
>
> Like this (again not yet tested)
>
> 8250: Remove NR_IRQ usage
>
> From: Alan Cox <alan@redhat.com>
>
>
> ---
>
>  drivers/serial/68328serial.c |   11 +------
>  drivers/serial/8250.c        |   68 +++++++++++++++++++++++++++++++++---------
>  2 files changed, 56 insertions(+), 23 deletions(-)
>

thanks. will test it.

YH
