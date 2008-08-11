Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYHKBUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYHKBUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 21:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbYHKBT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 21:19:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:49093 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbYHKBT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 21:19:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,341,1215414000"; 
   d="scan'208";a="605625410"
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
From: Zhao Yakui <yakui.zhao@intel.com>
To: S K <nospamnoham@gmail.com>
Cc: Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com>
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com>
	 <200808081430.43012.trenn@suse.de>
	 <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com>
	 <200808092059.47863.trenn@suse.de>
	 <514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 09:33:51 +0800
Message-Id: <1218418431.6671.52.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-10 at 01:28 -0700, S K wrote:
> On Sat, Aug 9, 2008 at 11:59 AM, Thomas Renninger <trenn@suse.de> wrote:
> > On Friday 08 August 2008 08:23:25 pm S K wrote:
> >> > Try updating the BIOS.
> >> > I expect your CPU is too new and the BIOS cannot export the correct freq
> >> > values for the specific CPU yet.
> >> >
> >> >      Thomas
> >>
> >> The BIOS is already at the latest version :( Is the above comment the
> >> only possible reason for the issue?
> >
> > It is very likely.
> 
> But Windows XP is able to do the scaling properly. So how can it be a
> BIOS issue? While reading about the Foxconn BIOS fiasco that happened
> recently a kernel dev (forgot his name) stated that Linux tries to
> emulate Windows for ACPI operations.
> 
> So I'm guessing this is a kernel bug.
>From the attached acpidump it seems that there is no definition of
_PCT,_PSS, _PPC. So acpi_cpufreq driver can't be used on your machine.
This is a BIOS issue. 

But it is very strange that cpufreq scaling can work on Windows XP.
Will you please try the P4 clock cpufreq driver and see whether the
scaling can work ? In fact P4 clock cpufreq driver is already replaced
by acpi_cpufreq driver for the latest cpu. 
Anyway please try p4 clock cpufreq driver.

Thanks.

> 
> -SK

