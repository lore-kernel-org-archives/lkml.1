Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbYAFPte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbYAFPte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 10:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbYAFPt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 10:49:27 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:31613 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbYAFPt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 10:49:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=JAmy25VXzzt5SI1gKhNQ1ohSurv1xvF2lFr03jjfxjrLcoOYJqY1eUOCs+WSxF9uFN8Hrd/zQqjP+DmaVbIhXu+0AQkyPj4yCV08EKYQbZdR0cKuYkM3SfPJcJnH6ulb5r2aKWj5jXWPryq4F8ahR9bywJnTNfjGEyPnRA08UFM=
Message-ID: <4780F880.8030903@gmail.com>
Date: Sun, 06 Jan 2008 16:49:20 +0100
From: =?ISO-8859-1?Q?Miguel_Bot=F3n?= <mboton@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] x86: ioport_{32|64}.c unification -v2
References: <4780EC61.4020007@gmail.com> <20080106150417.GA14146@elte.hu>
In-Reply-To: <20080106150417.GA14146@elte.hu>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Miguel Botón <mboton@gmail.com> wrote:
> 
>> ioport_{32|64}.c unification.
>>
>> This patch unifies the code from the ioport_32.c and ioport_64.c 
>> files.
>>
>> Tested and working fine with i386 and x86_64 kernels.
> 
> in what way have you tested it? Have you tried iopl() and ioperm() 
> syscalls to check whether they properly block/allow port IO?
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

I made a little app to check that iopl() and ioperm() were working properly.

---
	Miguel Botón
