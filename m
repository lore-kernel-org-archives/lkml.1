Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYHHIlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYHHIlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 04:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYHHIlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 04:41:40 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:61139 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbYHHIlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 04:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=jRiAErD9siKe1lP99qTvbIphxKZ1ohM2zDn50p4mWsKqv8n9/h/75uZ5RWo8AsI77b
         5VYN9+bEgQhxs7tGdTvohD9/p21jJ+mIP3E70M/xhQMzvUSbku7MyovifSL3gwuA6W3l
         nNbDBYLFG1NychpZnGFJF9LkgRnaT/8f6CnY4=
Message-ID: <489C06BE.2020309@tuffmail.co.uk>
Date: Fri, 08 Aug 2008 09:41:34 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: S K <nospamnoham@gmail.com>
CC: Zhao Yakui <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com>	 <48958901.06a0100a.35d6.2df9@mx.google.com>	 <514e099a0808032206n192fc973u24b31def6555dbec@mail.gmail.com>	 <514e099a0808070235qd36628cta191018763875422@mail.gmail.com>	 <1218159124.6671.32.camel@yakui_zhao.sh.intel.com> <514e099a0808072153w2e944037gbfbdf8e9156d7df0@mail.gmail.com>
In-Reply-To: <514e099a0808072153w2e944037gbfbdf8e9156d7df0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S K wrote:
> Hi,
>
> I already did the cpufreq.debug thing and it was using the
> smi_speedstep driver instread of the acpi_speedstep (or whatever is
> the right name).
>
> Alan already told me this is likely an ACPI issue. So, I already sent
> the acpidump in a prev email (Aug 3rd 08). I'm don't have access to my
> home machine right now. Will send it again later if you can't get my
> prev email from the archives.
>   

I could be completely wrong though!

I'd not heard of speedstep_smi before (now I look, it doesn't seem to be
an option in the cpu frequency scaling Kconfig menu?).

I assumed the error messages you had about SMI were just flack.  I
thought  acpi-cpufreq was the only option on recent machines - and that
a quad core  probably counts as recent.  The error messages could be due
to Fedora scripts unconditionally loading several different modules, to
find one that works.

I'm not sure how you can answer Zhao's question if you don't already
know.  I expect Fedora C7 does try loading acpi_cpufreq (as well as
speedstep_smi).  Whether your machine actually supports acpi_cpufreq is
the question we're trying to answer.  (This is where looking at Windows,
or BIOS settings, would help).

Alan
