Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbYGMBpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbYGMBpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 21:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYGMBpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 21:45:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:15743 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbYGMBpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 21:45:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O6x4s63gds/qc5srQGL8sjyo76jKqRxBK/2VaL7Ge3UI0Aq8ezTeMuDdzdajhBq+gM
         jMJewQXpE+PPJ61I5ZtJ/BsO5d+q2LT1vYQ1jm63gKmCK7yMyfPHlL+FgBFBaDgp2le1
         hG2kYPhGaAVqjS2V1OvjEyKTKxNQgT9VKBZUU=
Message-ID: <86802c440807121845u3a51b239h95fa46cfb6f7c770@mail.gmail.com>
Date: Sat, 12 Jul 2008 18:45:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.55.0807130241390.4128@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807080141.05436.yhlu.kernel@gmail.com>
	 <200807092017.51004.yhlu.kernel@gmail.com>
	 <200807102038.26591.yhlu.kernel@gmail.com>
	 <200807111841.55403.yhlu.kernel@gmail.com>
	 <Pine.LNX.4.55.0807130241390.4128@cliff.in.clinika.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 6:43 PM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
> On Fri, 11 Jul 2008, Yinghai Lu wrote:
>
>> -void apic_wait_icr_idle(void)
>> +void xapic_wait_icr_idle(void)
>>  {
>>       while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
>>               cpu_relax();
>>  }
>>
>> -u32 safe_apic_wait_icr_idle(void)
>> +u32 safe_xapic_wait_icr_idle(void)
>
>  Etc...  Why are you changing names of these functions?  Are they meant
> not to apply to older APIC implementations anymore?

because 64bit has that name.

YH
