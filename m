Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbYGRXEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbYGRXEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYGRXEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:04:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:42030 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbYGRXEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:04:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XetkcaeRjp9SUVwkspIB8ZK30MLGi0fAu9IYutVE4kmjU/jfzTzM3jaIm5NBBFxeT5
         RZLKCIz0s2cYyN1+jwHF33neEmMaen1GEZbTJGX+VMMLr2edz7h2oliHR3baJloDdEh3
         T6FSu6E6scFlq1CmOlJTT8wnEjA9BRIsMGa8o=
Message-ID: <86802c440807181604y502e7deal98abfeb1ceee769d@mail.gmail.com>
Date: Fri, 18 Jul 2008 16:04:29 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Cc: "Zachary Amsden" <zach@vmware.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Ingo Molnar" <mingo@elte.hu>, "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <20080718230012.GD4507@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.55.0807161837080.30858@cliff.in.clinika.pl>
	 <86802c440807180925t6fadfa58r6bf7740f8145482e@mail.gmail.com>
	 <86802c440807181001h4426c197vc474f81497a5b42@mail.gmail.com>
	 <20080718210348.GB24373@elte.hu>
	 <86802c440807181413n7e79e821l90afaae86b322de9@mail.gmail.com>
	 <Pine.LNX.4.55.0807182254270.12125@cliff.in.clinika.pl>
	 <1216420937.30348.30.camel@bodhitayantram.eng.vmware.com>
	 <20080718224922.GB4507@linux-os.sc.intel.com>
	 <86802c440807181551l7e6e143dy7cea8ab59f1830ed@mail.gmail.com>
	 <20080718230012.GD4507@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 4:00 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Fri, Jul 18, 2008 at 03:51:07PM -0700, Yinghai Lu wrote:
>> On Fri, Jul 18, 2008 at 3:49 PM, Suresh Siddha
>> <suresh.b.siddha@intel.com> wrote:
>> > Thanks to Maciej who posted this fix. It was on my todo list for
>> > sometime now!
>>
>> do we rebase tip/x86/x2apic or rework this patch?
>
> Ingo just did the merge. And I posted a missing piece. So is this enough?

maciej, patch will go first, and x2apic will goes later, so bisect on
x2apic will be broken.

YH
