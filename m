Return-Path: <linux-kernel-owner+w=401wt.eu-S1761856AbYHHVof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761856AbYHHVof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbYHHVoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:44:15 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:64026 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759308AbYHHVoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:44:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ftLDgPeMe9C+OUVCbQqQSggiVjUy/YxBNt90CzK/nBdNi/NxzAczrsLTMNMlTRuMGG
         MDKbvANhS4LTAbW0xCUxazE3bTPxvZ6xs6NsmM1Xixbn5A+SDaurgB50a7A5C1GdZngY
         aUUN6Xxa9Z6ujIR/J9rE+bmPsRYFhsu0WPOQA=
Message-ID: <86802c440808081444q45353d92xd2483f9bdfdf29c3@mail.gmail.com>
Date: Fri, 8 Aug 2008 14:44:12 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: + x86-kill-arch-x86-kernel-mpparsec-debugging-printk.patch added to -mm tree
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       rene.herman@keyaccess.nl, rene.herman@gmail.com
In-Reply-To: <20080808142847.9e4f33b2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808082051.m78KpZGC027833@imap1.linux-foundation.org>
	 <86802c440808081413u2249fff1g1940ff472cdf10e7@mail.gmail.com>
	 <20080808142847.9e4f33b2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2008 at 2:28 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 8 Aug 2008 14:13:29 -0700
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
>> > commit 11a62a056093a7f25f1595fbd8bd5f93559572b6 turns some formerly nopped
>> > debugging printks in arch/x86/kernel/mppparse.c into regular ones.  The
>> > one at the top of smp_scan_config() in particular also prints on
>> > !CONFIG_SMP/CONFIG_X86_LOCAL_APIC kernels and UP machines without anything
>> > resembling MP tables which makes their lowly UP owners wonder...
>> >
>> > Given that it was up to this point also not considered valuable user-level
>> > information, let's just kill that one.
>> >
>>
>> why?  that just three lines debug debug info.
>
> For the reasons described in the changelog text.  They look quite valid
> to me.

then how about system do have mptable ?

YH
