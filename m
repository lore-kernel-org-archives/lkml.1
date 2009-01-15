Return-Path: <linux-kernel-owner+w=401wt.eu-S1762667AbZAOVH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762667AbZAOVH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933835AbZAOUv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:51:56 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:12501 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934057AbZAOUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:51:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CS+T269RpCTPModsaW1k3cjomHe/JpZNp0UeTMnaFTCBVgRCvlLBFwAVEwSbhiCTnu
         GYscLpssloBhuGZvRoBy+FFxbZQMaoP8G/pKnJvE3ABsQfvRzZFnQhx9cOSPnOrRKsa9
         DBBhH7Jr8lGYN5eKdD1X0VYIQRJkY29/d45Ek=
MIME-Version: 1.0
In-Reply-To: <baeb34bc0901151150w4ad88du78d91f6db50983e1@mail.gmail.com>
References: <baeb34bc0901131746n33cd536co331e32361df2fb72@mail.gmail.com>
	 <adaeiz6k4o4.fsf@cisco.com>
	 <baeb34bc0901131910n55cae670qc9d02c9f78c6432@mail.gmail.com>
	 <86802c440901132207l433227d9nf149506012a5721e@mail.gmail.com>
	 <baeb34bc0901151150w4ad88du78d91f6db50983e1@mail.gmail.com>
Date: Thu, 15 Jan 2009 12:51:53 -0800
X-Google-Sender-Auth: 6d4c0146882dce48
Message-ID: <86802c440901151251t58077af9v783503cd7994cab1@mail.gmail.com>
Subject: Re: memory beyond4GB invisible to the system even though 
	CONFIG_HIGHMEM64G=y
From: Yinghai Lu <yinghai@kernel.org>
To: James Kirin <james.kirin40@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 11:50 AM, James Kirin <james.kirin40@gmail.com> wrote:
> Hi Yinghai,
>
>> please do
>> 1. boot linux with "disable_mtrr_trim" in grub.conf etc
>> 2. after booting input:
>> echo "base=0x100000000 size=0x20000000 type=write-back" >/proc/mtrr
>
> Thank you for your suggestion.
>
> Unfortunately, booting with disable_mtrr_trim leads to a kernel panic:
>
> [<c0103abb>] kernel_thread_helper+0x7/0x1c
> ===========
> Code: 0c 31 d2 89 e8 e8 c2 f4 ff ff 89 c3 eb 8e 8b 85 cc 00 00 00 89 44 24 10 83
> bd ec 00 01 00 04 0f 84 cf 00 00 00 8b 9d f0 00 01 00 <8b> 43 10 3b 43 0c 0f 84
> d5 00 00 00 8b 53 10 8b 85 ec 00 01 00
> EIP: [<c026bc2f] hid_parser_main+0xcf/0x290 SS:ESP 0068:f7c2bd7c
> ---[ end trace 34615b445589fbb6 ]---
> Kernel panic - not syncing: Attempted to kill init!
>
> I am attaching the kernel config file. The system boots fine if I
> remove "disable_mtrr_trim" from lilo.conf (and rerun lilo).
>
can you try mem=4g , .., and then mem=6g ...

YH
