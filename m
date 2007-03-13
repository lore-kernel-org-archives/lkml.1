Return-Path: <linux-kernel-owner+w=401wt.eu-S933741AbXCMV5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741AbXCMV5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 17:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933675AbXCMV5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 17:57:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:17173 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933741AbXCMV5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 17:57:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PcFZHf0dUIX7kH+8CZ8N/SDcM7ppNIx+y5nvQYOba8MVXfHOrYNaPT6VmJLqgKsgg+R9DlaxYytBGkxPjbHO6OlSBhGqYdSdP7dBJwNmTql2B8u+R9qTHisoaB6xaiINTZZNoKOcMDWHQfcy7I+3xpCuRzlsoQwD7C6I9oPuyro=
Message-ID: <29495f1d0703131457i43883529p5da1502b68ff0948@mail.gmail.com>
Date: Tue, 13 Mar 2007 14:57:26 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Linux 2.6.20.3
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@osdl.org>,
       torvalds@osdl.org, stable@kernel.org, davem@davemloft.net,
       sparclinux@vger.kernel.org
In-Reply-To: <20070313183353.GA7434@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070313183353.GA7434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/07, Greg KH <greg@kroah.com> wrote:
> We (the -stable team) are announcing the release of the 2.6.20.3 kernel.
> It contains a number of bugfixes and all 2.6.20 users are recommended to
> upgrade.
>
> The diffstat and short summary of the fixes are below.
>
> I'll also be replying to this message with a copy of the patch between
> 2.6.20.2 and 2.6.20.3.

Compared to 2.6.20.1 (will try 2.6.20.2 as well), I now get:

[  199.361347] BUG: soft lockup detected on CPU#2!

smp_percpu_timer_interrupt+0xd4/0x180
tl0_irq14+0x1c/0x20
journal_add_journal_head+0x2c/0x1e0
journal_write_metadata_buffer+0x480/0x500
journal_commit_transaction+0xc38/0x1040
kjournald+0xc0/0x1e0
kthread+0xb0/0xc0
kernel_thread+0x38/0x60
keventd_create_kthread+0x20/0xa0

shortly after the serial console prompts for login.

Thanks,
Nish
