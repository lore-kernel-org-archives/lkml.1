Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYHHKKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYHHKKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYHHKKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:10:32 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:33982 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbYHHKK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:10:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cl7JguMFz6epAjFwvczXnzkneIEv8MOU43FEnLtNOZHD3fGpTQKT+uczceF7Wr0yOE
         l4jC/BDG5yj9liRBZoERqMpQe3EadDu1GSlcMVq/4TFEccB1AULGJglhNDhs1mhpjf1u
         M7zf3T+2cl0fGz3dyR2BWh/O4nZg2maV/Mql4=
Message-ID: <514e099a0808080310n15d56d79k98587ca73111db59@mail.gmail.com>
Date: Fri, 8 Aug 2008 03:10:26 -0700
From: "S K" <nospamnoham@gmail.com>
To: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Cc: "Zhao Yakui" <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <489C06BE.2020309@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com>
	 <48958901.06a0100a.35d6.2df9@mx.google.com>
	 <514e099a0808032206n192fc973u24b31def6555dbec@mail.gmail.com>
	 <514e099a0808070235qd36628cta191018763875422@mail.gmail.com>
	 <1218159124.6671.32.camel@yakui_zhao.sh.intel.com>
	 <514e099a0808072153w2e944037gbfbdf8e9156d7df0@mail.gmail.com>
	 <489C06BE.2020309@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2008 at 1:41 AM, Alan Jenkins
<alan-jenkins@tuffmail.co.uk> wrote:
> S K wrote:
>> Hi,
>>
>> I already did the cpufreq.debug thing and it was using the
>> smi_speedstep driver instread of the acpi_speedstep (or whatever is
>> the right name).
>>
>> Alan already told me this is likely an ACPI issue. So, I already sent
>> the acpidump in a prev email (Aug 3rd 08). I'm don't have access to my
>> home machine right now. Will send it again later if you can't get my
>> prev email from the archives.
>>
>
> I could be completely wrong though!
>
> I'd not heard of speedstep_smi before (now I look, it doesn't seem to be
> an option in the cpu frequency scaling Kconfig menu?).
>
> I assumed the error messages you had about SMI were just flack.  I
> thought  acpi-cpufreq was the only option on recent machines - and that
> a quad core  probably counts as recent.  The error messages could be due
> to Fedora scripts unconditionally loading several different modules, to
> find one that works.
>
> I'm not sure how you can answer Zhao's question if you don't already
> know.  I expect Fedora C7 does try loading acpi_cpufreq (as well as
> speedstep_smi).  Whether your machine actually supports acpi_cpufreq is
> the question we're trying to answer.  (This is where looking at Windows,
> or BIOS settings, would help).
>
> Alan
>

My machine has acpi-cpufreq module, but when I try to load it, I get:
FATAL: Error inserting acpi_cpufreq
(/lib/modules/2.6.25.11-97.fc9.i686/kernel/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.ko):
No such device

Btw, yes, cpu freq scaling works in Windows XP. What should I look for
in Windows?

I build my own system, so I have gone through my system BIOS several
times and don't remember anything related to freq scaling. But I will
check again.

Btw, my machine is a Shuttle SG33G5. It has other issues too but right
now heat is the biggest concern.

Thanks,
SK
