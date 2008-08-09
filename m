Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbYHITOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbYHITOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 15:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYHITN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 15:13:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:44171 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbYHITNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 15:13:55 -0400
From: Thomas Renninger <trenn@suse.de>
To: "S K" <nospamnoham@gmail.com>
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Date: Sat, 9 Aug 2008 21:30:14 +0200
User-Agent: KMail/1.9.9
Cc: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Zhao Yakui" <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com> <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com> <200808092059.47863.trenn@suse.de>
In-Reply-To: <200808092059.47863.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808092130.14719.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

just that in case you try out kernels...

On Saturday 09 August 2008 08:59:47 pm Thomas Renninger wrote:
> On Friday 08 August 2008 08:23:25 pm S K wrote:

> Mark Langsdorf reported some acpi breakage in .27-rc1, this could also be
> the reason.
---------
> I got a regression when updated from 2.6.27-rc1 ro
> 2.6.27-rc2.  The noticeable symptom is the powernow-k8
> driver stopped working because the call to 
> acpi_processor_register_performance() is returning
> -EINVAL.
----------

So it's rc2 not rc1, but AFAIK your report should be older than rc2.

There also was a similar report from Laurence Darby <ldarby@tuffmail.com>.
He still posted on the old cpufreq list.
Subject: Core 2 Duo E8400 stepping 6 not recognised

A BIOS update helped.
You may be able to google this out and compare his CPU_FREQ_DEBUG logs.

      Thomas
