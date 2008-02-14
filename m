Return-Path: <linux-kernel-owner+w=401wt.eu-S1763926AbYBNOBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763926AbYBNOBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 09:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYBNOBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 09:01:14 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:61487 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbYBNOBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 09:01:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nwqI5FGxtn9/+Iz6IQHUa/8o6sm03Dtfn0syW3T9LJrmLrB0vmUap2Ks93eLh1Jc2JWWRyZU4qXAZ5UFnVHv7xMmhzSgqmLmMTOrAIMKBhhUbDUBfc1WLo6xJcknXfoS9DoKyQtUxpteIL90hTLOJ6IeVWcDYv3uGY8Di0ellM4=
Message-ID: <df9815e70802140601i610574c7t782a618db414c7c9@mail.gmail.com>
Date: Thu, 14 Feb 2008 22:01:11 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: nmi_watchdog on x86_64
Cc: "Andi Kleen" <ak@suse.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440710151912n3b288dc4na06a9abb2addacf4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440710151912n3b288dc4na06a9abb2addacf4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 10:12 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> just found my on hand ck804, and mcp55 based AMD servers:
>  nmi_watchdog=1 doesn't work
>  but nmi_watchdog=2 does work
>
>  =1, it say: IOAPIC 8259A virtual wire mode...
>
>  Did nmi_watchdog=1 work on any other amd64 platform?
>

I booted 2.6.23 on a HP NX6325 laptop with nmi_watchdog=1, and dmesg says,

...
..MP-BIOS bug: 8254 timer not connected to IO-APIC
timer doesn't work through the IO-APIC - disabling NMI Watchdog!

nmi_watchdog remains to be 0, as I read by a simple kernel module.

Regards,
Jike
