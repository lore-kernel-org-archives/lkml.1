Return-Path: <linux-kernel-owner+w=401wt.eu-S1751330AbYHKEpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbYHKEpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 00:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750725AbYHKEow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 00:44:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:30370 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYHKEov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 00:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mRHTx3rqtthxcNPS0wKkunU6ukHph4VqNc2SjjDo7qkeWpWs4j3mZrTdBnMBgfMFge
         klZltQb8qmu1kFe+oc2I4M1piEQSot4BCC27LAPsAE4Sg/IaIdhUEq7zRSy4CZjkGAg0
         NQCm64ih39jYwvDIt4ejI2CTy+Pj8Sn/7ueeI=
Message-ID: <514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com>
Date: Sun, 10 Aug 2008 21:44:50 -0700
From: "S K" <nospamnoham@gmail.com>
To: "Zhao Yakui" <yakui.zhao@intel.com>
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Cc: "Thomas Renninger" <trenn@suse.de>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <1218418431.6671.52.camel@yakui_zhao.sh.intel.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> So I'm guessing this is a kernel bug.
> >From the attached acpidump it seems that there is no definition of
> _PCT,_PSS, _PPC. So acpi_cpufreq driver can't be used on your machine.
> This is a BIOS issue.

Yakui, Did you actually check if the above was true?

>
> But it is very strange that cpufreq scaling can work on Windows XP.
> Will you please try the P4 clock cpufreq driver and see whether the
> scaling can work ? In fact P4 clock cpufreq driver is already replaced
> by acpi_cpufreq driver for the latest cpu.
> Anyway please try p4 clock cpufreq driver.

What is the name of the driver? I'm not able to find any such driver
in Fedora 9 installed modules. There is only acpi-cpufreq and powernow-k8.

Also, If someone doesn't mind, can they tell me what all files I need to
replace in Fedora 9 once I get a kernel.org kernel compiled? I know
how to edit grub.conf,
and that I should replace vmlinuz, but do I need to replace initrd too?

Thanks,
SK
