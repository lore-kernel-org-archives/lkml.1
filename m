Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbYHHMaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbYHHMaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 08:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbYHHMaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 08:30:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:55633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625AbYHHMap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 08:30:45 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: "S K" <nospamnoham@gmail.com>
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Date: Fri, 8 Aug 2008 14:30:41 +0200
User-Agent: KMail/1.9.9
Cc: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Zhao Yakui" <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com> <514e099a0808080310n15d56d79k98587ca73111db59@mail.gmail.com> <514e099a0808080343y41f279fbhc10b1539bfddb548@mail.gmail.com>
In-Reply-To: <514e099a0808080343y41f279fbhc10b1539bfddb548@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081430.43012.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 August 2008 12:43:02 S K wrote:
> On 8/8/08, S K <nospamnoham@gmail.com> wrote:
> > My machine has acpi-cpufreq module, but when I try to load it, I get:
> >  FATAL: Error inserting acpi_cpufreq
> > 
> > (/lib/modules/2.6.25.11-97.fc9.i686/kernel/arch/x86/kernel/cpu/cpufreq/ac
> >pi-cpufreq.ko): No such device
> >
> >  Btw, yes, cpu freq scaling works in Windows XP. What should I look for
> >  in Windows?
> >
> >  I build my own system, so I have gone through my system BIOS several
> >  times and don't remember anything related to freq scaling. But I will
> >  check again.
>
> There is a "PPM mode" option which has possible values:
> Native - Native mode is for fully support ACPI OS (ex. Win XP, Vista)
> SMM - SMM mode is for legacy OS (ex. Win 2k)
>
> Setting it to SMM didn't help. Gave the same error for acpi_cpufreq.
>
> Btw, you were right about FC trying all the module, but it apparently
> tried only speedstep modules for some reason. It's clear from my
> dmesg.txt that all the speedstep modules are attempted.
>
> Forgot one obvious thing when I ran dmesg -- forgot to run it after
> trying modprobe acpi_cpufreq.
> This is what I get when I do that:
>
> acpi-cpufreq: acpi_cpufreq_init
> acpi-cpufreq: acpi_cpufreq_early_init
> cpufreq-core: trying to register driver acpi-cpufreq
> cpufreq-core: adding CPU 0
> acpi-cpufreq: acpi_cpufreq_cpu_init
> cpufreq-core: initialization failed
> cpufreq-core: adding CPU 1
> acpi-cpufreq: acpi_cpufreq_cpu_init
> cpufreq-core: initialization failed
> cpufreq-core: adding CPU 2
> acpi-cpufreq: acpi_cpufreq_cpu_init
> cpufreq-core: initialization failed
> cpufreq-core: adding CPU 3
> acpi-cpufreq: acpi_cpufreq_cpu_init
> cpufreq-core: initialization failed
> cpufreq-core: no CPU initialized for driver acpi-cpufreq
> cpufreq-core: unregistering CPU 0
> cpufreq-core: unregistering CPU 1
> cpufreq-core: unregistering CPU 2
> cpufreq-core: unregistering CPU 3
>
> Attaching the files I sent to Zaho so others can look at it too.

Try updating the BIOS.
I expect your CPU is too new and the BIOS cannot export the correct freq 
values for the specific CPU yet.

      Thomas
