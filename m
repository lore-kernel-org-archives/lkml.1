Return-Path: <linux-kernel-owner+w=401wt.eu-S1765315AbYBNJp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765315AbYBNJp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 04:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYBNJpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 04:45:19 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:11563 "EHLO
	outbound9-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878AbYBNJpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 04:45:16 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JW82ZO-01-827-01
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Thu, 14 Feb 2008 10:40:36 +0100
From: "Robert Richter" <robert.richter@amd.com>
To: "Arjan van de Ven" <arjan@infradead.org>
cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] x86: apic: Export symbols for extended
 interrupt LVT functions
Message-ID: <20080214094036.GA16892@erda.amd.com>
References: <20080213151811.804698000@amd.com>
 <20080213151841.520543000@amd.com>
 <20080213143256.54e9a3c7@laptopd505.fenrus.org>
MIME-Version: 1.0
In-Reply-To: <20080213143256.54e9a3c7@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 14 Feb 2008 09:40:36.0570 (UTC)
 FILETIME=[A6DA7BA0:01C86EED]
X-WSS-ID: 6BAAD29424S11765478-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.02.08 14:32:56, Arjan van de Ven wrote:
> On Wed, 13 Feb 2008 16:19:36 +0100 (CET)
> "Robert Richter" <robert.richter@amd.com> wrote:
> 
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > ---
> >  arch/x86/kernel/apic_64.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
> > index d8d03e0..2a9f4bc 100644
> > --- a/arch/x86/kernel/apic_64.c
> > +++ b/arch/x86/kernel/apic_64.c
> > @@ -215,12 +215,14 @@ u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type,
> > u8 mask) setup_APIC_eilvt(APIC_EILVT_LVTOFF_MCE, vector, msg_type,
> > mask); return APIC_EILVT_LVTOFF_MCE;
> >  }
> > +EXPORT_SYMBOL(setup_APIC_eilvt_mce);
> >  
> >  u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
> >  {
> >  	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type,
> > mask); return APIC_EILVT_LVTOFF_IBS;
> >  }
> > +EXPORT_SYMBOL(setup_APIC_eilvt_ibs);
> 
> which modules would even consider using any of these?
> Doesn't sound like something we should export..

For IBS it is Perfmon. See here:
http://git.kernel.org/?p=linux/kernel/git/eranian/linux-2.6.git;a=commit;h=7caef3e19d17349f869884f5adf7c9823e32ade7

MCE export has been added for consistency reasons to allow modules to
enable MCE.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


