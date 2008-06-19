Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbYFSGgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbYFSGgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 02:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbYFSGgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 02:36:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:23876 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbYFSGf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 02:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UMRdErxs0SQzypIjGlvGzSoqB5uXiGn3YXx6Enu86Y76iD8AMDg1Mom5p4Ifbl6J5m
         XOGqk+RfQayCZBrM5C6XQNFhnP4UbjKmfV+9/Zho4OM6xlavoGoDYRXIzJCdR1Ndn/ND
         2gXZbYacRqb9y2BJOS7ZS2LvAqiJhKkcYgxHM=
Message-ID: <86802c440806182335i6434a7ecj512dae852c4a41eb@mail.gmail.com>
Date: Wed, 18 Jun 2008 23:35:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: update mptable v7
Cc: "Len Brown" <lenb@kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4859FCA4.4050606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805041823.57198.yhlu.kernel@gmail.com>
	 <200805251600.26325.yhlu.kernel@gmail.com>
	 <200806011317.38622.yhlu.kernel@gmail.com>
	 <alpine.LFD.1.10.0806181812580.3074@localhost.localdomain>
	 <86802c440806181532g348864e1u3d067f8366046a7f@mail.gmail.com>
	 <alpine.LFD.1.10.0806182031060.3074@localhost.localdomain>
	 <86802c440806181749g2faf1892iea693717ea919631@mail.gmail.com>
	 <alpine.LFD.1.10.0806190113290.3613@localhost.localdomain>
	 <86802c440806182326m8c3ad56j29242895507e074d@mail.gmail.com>
	 <4859FCA4.4050606@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 11:28 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>>
>>> Can somebody clue me into why this concept
>>> is something other than totally insane?
>>
>> for system that have 6 pcie slots and more, with full populated cards.
>> when boot with mptable, BIOS will use irq < 16 for all pci devices,
>> and several devices will share same irq.
>> but when acpi is enabled, irqs are spanned all over.
>>
>> also when pci card with several pci bridges is plugged in, the mptable
>> is totally messed up, some slot will work, and some doesn't work.
>
> And the reason to worry about supporting non-ACPI on such hardware is what?

1. some other os doesn't support acpi well, and still use mptable.
2. show BIOS engineer how to fix mptable.

YH
