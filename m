Return-Path: <linux-kernel-owner+w=401wt.eu-S1751505AbYHKFY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbYHKFY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 01:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbYHKFYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 01:24:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:31019 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYHKFYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 01:24:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=f13Oba0Mn7wJ3sYqHdYJCaikZ7/uB5SjEVYjpuhdXNHO/tlKwJQ8Ax8aIolwwaFxJ4
         ENGrrudUM1V6g7kgZK9nu9NOT2jY54aw7D33eBfDLPkSOiXRvJL+adGA/RC/e0lf2IrP
         9P90/d3tqX8MXwmJKc7kgKcJstBjTQmHdM4Iw=
Message-ID: <514e099a0808102224g6f55fa0ex5f50d8f21f838358@mail.gmail.com>
Date: Sun, 10 Aug 2008 22:24:19 -0700
From: "S K" <nospamnoham@gmail.com>
To: "Zhao Yakui" <yakui.zhao@intel.com>
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Cc: "Thomas Renninger" <trenn@suse.de>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <1218432270.6671.75.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com>
	 <200808081430.43012.trenn@suse.de>
	 <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com>
	 <200808092059.47863.trenn@suse.de>
	 <514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com>
	 <1218418431.6671.52.camel@yakui_zhao.sh.intel.com>
	 <514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com>
	 <1218432270.6671.75.camel@yakui_zhao.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Yakui, Did you actually check if the above was true?
> Yes. There is no definition of _PSS,_PCT,_PPC in DSDT table, which are
> required by acpi_cpufreq driver.At the same time there is no extra SSDT
> table.

So what's the significance of "no extra SSDT table"? Does that mean that XP
and Linux are using the same tables to check for freq scaling support?

> The driver is P4-clockmod, which is located in the directory of
> arch/x86/kernel/cpu/cpufreq

Thanks. I just looked at the kernel.org kernel (what's the term used
in lkml for this?) and found out the switch.
I got the kernel.org kernel compiled with the .config used for the F9
kernel. Now I need figure out how to get it to boot.

Btw, on your suggestion, I opened a bug for this issue.
http://bugzilla.kernel.org/show_bug.cgi?id=11299

Does the LKML community consider the Fedora 9 kernels as too different?
I would prefer using the F9 kernel for testing this issue since it's
easier for me to compile and install.

I got some important stuff to deal with for the next couple of days.
So I will get back on this thread in 2-4 days.

Thanks,
SK
