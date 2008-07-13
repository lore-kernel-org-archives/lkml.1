Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbYGMHF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbYGMHF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 03:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYGMHFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 03:05:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:57661 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbYGMHFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 03:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=feMvXFpFctNwEJeaO3kyV1NWHB6UpWcjeW/ERmwTmpZ9w1ndmjek/7weZI86PmBxoG
         BdWBzrMRJ7G63nypsIREmwdhL90jWmHhQwf+nMEL6I7F3ehqKPLZp+camFOs5SR8DVzz
         ZBratO9BWWsXmONhZ/ItwTnoOY8tnRBO/JySs=
Message-ID: <86802c440807130005x721b781dy6d4b569f4c736a22@mail.gmail.com>
Date: Sun, 13 Jul 2008 00:05:19 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: make 64bit have get_apic_id
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080713065917.GA29634@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807080141.05436.yhlu.kernel@gmail.com>
	 <200807111843.11157.yhlu.kernel@gmail.com>
	 <200807111844.17084.yhlu.kernel@gmail.com>
	 <200807120101.20554.yhlu.kernel@gmail.com>
	 <20080713062802.GC2534@elte.hu> <20080713065917.GA29634@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 11:59 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>> > and read_apic_id become macro
>> > GET_APIC_ID(apic_read(APIC_ID))
>
> Yinghai, you had that x86/x2apic crash - do you think we can now try it
> again in tip/master?

Yes. it looks good now. I test it for two days already. no problem found.

YH
