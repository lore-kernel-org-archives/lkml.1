Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYEZSGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYEZSGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 14:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYEZSG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 14:06:29 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:28875 "EHLO
	outbound2-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753274AbYEZSG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 14:06:28 -0400
X-BigFish: VPS-32(zz1432R98dR62a3L7efV1805M873fnzz10d3izz5a6ciz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K1HMAB-02-C6N-01
Date: Mon, 26 May 2008 20:06:16 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: Enable mmconf access to PCI ECS for all AMD fam10h systems
Message-ID: <20080526180616.GB2752@erda.amd.com>
References: <20080523124622.GV27511@erda.amd.com> <86802c440805231057v659e5c7ahfd0407d46ef34bfd@mail.gmail.com> <20080523111825.580423e1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080523111825.580423e1@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 26 May 2008 18:06:16.0777 (UTC) FILETIME=[31292B90:01C8BF5B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Yinghai and Arjan,

On 23.05.08 11:18:25, Arjan van de Ven wrote:
> On Fri, 23 May 2008 10:57:22 -0700
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> > Someone express the concern about touching MSR. Arjan or Andi?
> > 
> > for those of system that doesn't have MCFG table there, they could use
> > pci=check_enable_amd_mmconf to enable it forcely.
> 
> using MMIO if the bios doesn't allow it via MCFG is a huge mistake and
> shouldn't be done.

I see your concerns here, though it could possibly be save for access
to processor config space only. Andi also stated before the BIOS
should do the work.

> Using the extended port IO version is actually perfectly reasonable to
> me and I would encourage that to be in the kernel (and be used in favor
> of MCFG if the port IO method is there)

Glad to hear that IO access code is also accepted to access ECS, at
least for segment 0. I already submitted patches for this some times
ago and will send an update. This would ensure access to ECS of
processor config space if MMCONFIG is disabled. Also, this could be a
solution for 32bit code.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

