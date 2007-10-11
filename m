Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbXJKOzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbXJKOzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 10:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXJKOyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 10:54:54 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:42376 "EHLO
	mail34-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbXJKOyx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 10:54:53 -0400
X-Greylist: delayed 3185 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 10:54:53 EDT
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
From: "Christoph Egger" <Christoph.Egger@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] x86: mce init optimization and signedness fixup
Date: Thu, 11 Oct 2007 16:01:02 +0200
User-Agent: KMail/1.9.6
cc: "Joerg Roedel" <joerg.roedel@amd.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <11921050742274-git-send-email-joerg.roedel@amd.com>
 <1192105075473-git-send-email-joerg.roedel@amd.com>
 <alpine.LFD.0.9999.0710111550400.15917@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710111550400.15917@localhost.localdomain>
MIME-Version: 1.0
Message-ID: <200710111601.02630.Christoph.Egger@amd.com>
X-OriginalArrivalTime: 11 Oct 2007 14:01:22.0302 (UTC)
 FILETIME=[346339E0:01C80C0F]
X-WSS-ID: 6B10F33E2ZC1685293-01-01
Content-Disposition: inline
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 October 2007 15:51:49 Thomas Gleixner wrote:
> On Thu, 11 Oct 2007, Joerg Roedel wrote:
> > MCG_CAP never reports a negative count of available error-reporting
> > banks. Therefore, make nr_mce_banks unsigned.
> > Check for MCA/MCE feature bits as early as possible.
> >
> > +
> > +	if (!cpu_has(c, X86_FEATURE_MCA) || !cpu_has(c, X86_FEATURE_MCE)) {
> > +		printk(KERN_INFO "CPU%i: No machine check support available\n",
> > +			smp_processor_id());
> > +		return;
>
> This breaks winchip MCE support.

First, what is a winchip? It sounds to be something windows specific. ;)
Second, can you explain in which way MCE support gets broken, please?

If you actually see the printk message, then machine check
support is not available on that cpu on that machine, right?


-- 
AMD Saxony, Dresden, Germany
Operating System Research Center

Legal Information:
AMD Saxony Limited Liability Company & Co. KG
Sitz (Geschäftsanschrift):
   Wilschdorfer Landstr. 101, 01109 Dresden, Deutschland
Registergericht Dresden: HRA 4896
vertretungsberechtigter Komplementär:
   AMD Saxony LLC (Sitz Wilmington, Delaware, USA)
Geschäftsführer der AMD Saxony LLC:
   Dr. Hans-R. Deppe, Thomas McCoy


