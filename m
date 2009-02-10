Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZBJUqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZBJUqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbZBJUp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:45:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:35777 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbZBJUp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:45:56 -0500
Message-ID: <4991E752.8010903@kernel.org>
Date: Tue, 10 Feb 2009 12:45:06 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Morten P.D. Stevens" <mstevens@win-professional.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3
 on IBM x3400
References: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com> <B4ED8DE8E195E84A872496A085BC07822F1D@exchange01.corp.win-professional.com> <20090209234528.GA862@elte.hu> <4990E90D.30005@kernel.org> <B4ED8DE8E195E84A872496A085BC07822F21@exchange01.corp.win-professional.com> <86802c440902101052m223792ddi43d27423844b1d5b@mail.gmail.com> <B4ED8DE8E195E84A872496A085BC07822F22@exchange01.corp.win-professional.com>
In-Reply-To: <B4ED8DE8E195E84A872496A085BC07822F22@exchange01.corp.win-professional.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Morten P.D. Stevens wrote:
> Hi,
> 
>> the line before this? it should tell why BIOS set the mask wrong.
> 
> [    0.000000] mtrr: BIOS set mask_lo: fcffff80 should be ffffff80,
> fixing it up

so BIOS miss two bits in var mtrr regs

can you post /proc/mtrr in 2.6.29-rc3 and old kernel without warn_on..?

YH
